//
//  SnapshotTestCase.swift
//  SnapshotTests
//
//  Created by Yuya Hirayama on 2022/03/29.
//

import Foundation
import XCTest
import SwiftUI
import SnapshotTesting
@testable import App

@MainActor class SnapshotTestCase: XCTestCase {
    private var isRecording: Bool {
        ProcessInfo.processInfo.environment["IS_RECORDING"] == "1"
    }

    private var snapshotDirectory: String? {
        ProcessInfo.processInfo.environment["SNAPSHOT_REFERENCE_DIR"]!
    }

    func assertScreenSnapshot<V: View>(matching view: V, shouldCaptureFullscreen: Bool, file: StaticString = #file, testName: String = #function, line: UInt = #line) {
        let vc = UIHostingController(rootView: view.tint(Color(uiColor: .systemBackground)))
            .embedInNavigationController()

        guard let failMessage = verifySnapshot(
            of: vc,
            as: .image(on: shouldCaptureFullscreen ? .fullScreen : .iPhoneXsMax),
            record: isRecording,
            snapshotDirectory: snapshotDirectory,
            testName: testName
        ) else {
            return
        }

        XCTFail(failMessage, file: file, line: line)
    }
}
