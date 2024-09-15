//
//  CategorizedEvents.swift
//  AppQualityAssurance
//
//  Created by Yuya Hirayama on 2022/06/05.
//

import Foundation

public protocol CategorizedEvents: Sendable {
    static var categoryName: String { get }

    var eventName: String { get }

    var parameters: [String: CustomStringConvertible] { get }

    var logLevel: LogLevel { get }
    var content: LogMessage { get }
}

public extension CategorizedEvents {
    var categoryName: String {
        Self.categoryName
    }
}

public enum LogLevel {
    case debug
    case info
    case notice
    case error
    case fault(errorCode: Int)
}
