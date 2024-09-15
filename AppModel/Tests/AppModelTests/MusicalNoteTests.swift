//
//  LetterNotation.swift
//  
//
//  Created by Yuya Hirayama on 2023/12/21.
//

import XCTest
@testable import AppModel

final class LetterNotationTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_半音上げ下げ() throws {
        XCTAssertEqual(LetterNotation.c.advanced(0), .c)
        XCTAssertEqual(LetterNotation.c.advanced(1), .cSharp)
        XCTAssertEqual(LetterNotation.c.advanced(-1), .b)
        XCTAssertEqual(LetterNotation.c.advanced(12), .c)
        XCTAssertEqual(LetterNotation.c.advanced(24), .c)
        XCTAssertEqual(LetterNotation.c.advanced(-12), .c)
        XCTAssertEqual(LetterNotation.c.advanced(-24), .c)
    }

    func test_2音間の距離() throws {
        XCTAssertEqual(LetterNotation.d.distance(from: .c), 2)
        XCTAssertEqual(LetterNotation.c.distance(from: .d), 10)

        XCTAssertEqual(LetterNotation.b.distance(from: .c), 11)
    }

    func test_degreeの計算() throws {
        XCTAssertEqual(LetterNotation.d.degree(scaleRoot: .c), .II)
        XCTAssertEqual(LetterNotation.b.degree(scaleRoot: .c), .VII)
        XCTAssertEqual(LetterNotation.d.degree(scaleRoot: .b), .flattedIII)
    }
}
