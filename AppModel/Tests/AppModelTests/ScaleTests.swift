//
//  ScaleTests.swift
//  
//
//  Created by Yuya Hirayama on 2023/12/21.
//

import XCTest
@testable import AppModel

final class ScaleTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_メジャースケールの構成音() throws {
        do {
            let actual = Scale.major(rootNote: .c).orderedNotes
            let expected = [LetterNotation.c, .d, .e, .f, .g, .a, .b]
            
            XCTAssertEqual(actual, expected)
        }
        
        do {
            let actual = Scale.major(rootNote: .d).orderedNotes
            let expected = [LetterNotation.d, .e, .fSharp, .g, .a, .b, .cSharp]
            
            XCTAssertEqual(actual, expected)
        }
    }
}
