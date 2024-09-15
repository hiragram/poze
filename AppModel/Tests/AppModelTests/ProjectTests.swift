//
//  ProjectTests.swift
//  
//
//  Created by Yuya Hirayama on 2024/01/05.
//

import XCTest
@testable import AppModel

final class ProjectTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_LatestStructureVersionが変わっていない() throws {
        let actual = LatestStructureVersion.version
        let expected = 2

        XCTAssertEqual(actual, expected)
    }
}

protocol ProjectStructureTests: XCTestCase {
    func test_saveしてloadできる() async throws
    func test_saveしてlatestまで変換できる() async throws
    func test_saveしてlatestまで変換してsaveできる() async throws
}
