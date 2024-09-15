//
//  MockPresenterProtocol.swift
//
//  Created by Yuya Hirayama on 2022/04/03.
//

import Foundation

@MainActor public protocol MockPresenterProtocol: AnyObject {
    @MainActor init()
    
    static var mockPresenters: [Self] { get }
    
    var shouldCaptureFullscreen: Bool { get }

    var previewName: String? { get set }
}

public extension MockPresenterProtocol {
    static func with(previewName: String, _ modifyBlock: (inout Self) -> Void) -> Self {
        var presenter = Self()
        modifyBlock(&presenter)
        presenter.previewName = previewName
        return presenter
    }

    var shouldCaptureFullscreen: Bool {
        false
    }

    func modified(_ block: (Self) -> Void) -> Self {
        block(self)

        return self
    }
}

protocol SkipSnapshotTestAutoGeneration {}
