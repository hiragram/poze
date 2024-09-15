//
//  ProjectFileManagerTests.swift
//  
//
//  Created by Yuya Hirayama on 2024/01/05.
//

import XCTest
@testable import AppRepository

final class ProjectFileManagerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_sharedの保存先ディレクトリ() throws {
        let actual = try ProjectFileManager.shared.projectsDirectoryURL
        let expected = try FileManager.default
            .url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("projects", isDirectory: true)

        XCTAssertEqual(actual, expected)
    }

    func test_プロジェクトファイルの拡張子が変わっていない() throws {
        let actual = ProjectFileManager.projectFileExtension
        let expected = "msproj"

        XCTAssertEqual(actual, expected)
    }
}
