//
//  UserInteractionAwaiter.swift
//  AppCore
//
//  Created by hiragram on 2023/05/03.
//

import Foundation
import SwiftUI

protocol UserInteractionAwaiter: PresenterProtocol, AnyObject {
    associatedtype ResultType

    var selectAndDismiss: ((ResultType) -> Void)? { get set }
}

extension RouterProtocol {
//    func userSelection<V: SwiftUI.View & VIPERScreen, P: UserInteractionAwaiter>(_ screenType: V.Type, presenter: P, useNavigationController: Bool = false, modifier: @escaping (UIViewController) -> Void = { _ in }) async throws -> P.ResultType where V.Presenter == P {
//        try await withCheckedThrowingContinuation({ [weak viewController] continuation in
//            Task { @MainActor [weak viewController] in
//                var alreadyCompleted = false
//
//                let onDeinit: () -> Void = {
//                    guard alreadyCompleted else {
//                        continuation.resume(throwing: UserSelectionError.dismissedWithNoSelection)
//                        alreadyCompleted = true
//                        return
//                    }
//                }
//
//                let destination: UIViewController
//                if useNavigationController {
//                    destination = ViewConstructor.build(screenType, presenter: presenter, onDeinit: onDeinit)
//                        .embedInNavigationController()
//                } else {
//                    destination = ViewConstructor.build(screenType, presenter: presenter, onDeinit: onDeinit)
//                }
//
//                modifier(destination)
//
//                presenter.selectAndDismiss = { [weak destination] result in
//                    Task { @MainActor in
//                        destination?.dismiss(
//                            animated: true,
//                            completion: {
//                                if !alreadyCompleted {
//                                    continuation.resume(returning: result)
//                                    alreadyCompleted = true
//                                }
//                        })
//                    }
//                }
//
//                viewController?.present(destination, animated: true)
//            }
//        })
//    }
}

enum UserSelectionError: LocalizedError {
    case dismissedWithNoSelection

    var errorDescription: String? {
        switch self {
        case .dismissedWithNoSelection:
            return LocalizedData(
                en: "User canceled selection",
                ja: "選択を中止しました"
            ).localized
        }
    }
}
