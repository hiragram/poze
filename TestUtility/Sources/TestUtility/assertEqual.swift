//
//  File.swift
//  
//
//  Created by Yuya Hirayama on 2024/01/21.
//

import Foundation
import XCTest

public func assertEqual<Target, each Property: Equatable>(
    _ actual: Target,
    _ expected: Target,
    keyPaths: repeat KeyPath<Target, (each Property)>,
    file: StaticString = #filePath,
    line: UInt = #line
) {
    repeat runAssertion(
        actual[keyPath: each keyPaths],
        expected[keyPath: each keyPaths],
        message: String(describing: each keyPaths),
        file: file,
        line: line
    )
}

func runAssertion<T: Equatable>(_ actual: T, _ expected: T, message: String, file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertEqual(
        actual,
        expected,
        message,
        file: file,
        line: line
    )
}
