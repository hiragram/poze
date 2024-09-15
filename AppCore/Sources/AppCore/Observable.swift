//
//  File.swift
//  
//
//  Created by Yuya Hirayama on 2024/04/13.
//

import Foundation

public extension Observable where Self: AnyObject {
    @available(*, unavailable)
    func observeChange<T>(keyPath: KeyPath<Self, T>) -> AsyncStream<T?> {
        AsyncStream { continuation in
            @Sendable func observe() {
                let result = withObservationTracking { [weak self] in
                    self?[keyPath: keyPath]
                } onChange: {
                    DispatchQueue.main.async {
                        observe()
                    }
                }
                continuation.yield(result)
            }

            observe()
        }
    }

    func observeChange<T>(keyPath: KeyPath<Self, T>, onChange: @escaping @MainActor @Sendable (T) async -> Void) -> ObservationCanceler {
        let canceler = ObservationCanceler()
        observeChange(keyPath: keyPath, canceler: canceler, onChange: onChange)

        return canceler
    }

    private func observeChange<T>(keyPath: KeyPath<Self, T>, canceler: ObservationCanceler, onChange: @escaping @MainActor @Sendable (T) async -> Void) {

        _ = withObservationTracking({
            self[keyPath: keyPath]
        }, onChange: { [weak self] in
            guard let _self = self else {
                return
            }

            guard !canceler.isCanceled else {
                return
            }

            Task { @MainActor in
                await onChange(_self[keyPath: keyPath])
            }
            _self.observeChange(keyPath: keyPath, canceler: canceler, onChange: onChange)
        })
    }
}

public class ObservationCanceler {
    fileprivate var isCanceled: Bool = false

    deinit {
        cancel()
    }

    public func cancel() {
        isCanceled = true
    }
}
