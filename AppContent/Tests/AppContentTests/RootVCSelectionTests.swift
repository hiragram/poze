//
//  RootVCSelectionTests.swift
//  
//
//  Created by Yuya Hirayama on 2023/11/29.
//

import XCTest
@testable import AppContent

final class RootVCSelectionTests: XCTestCase {
    func test_起動時にMain画面が選択される() throws {
        XCTAssertEqual(RootVCSelection.preferredRootVC(), .main)
    }
}
