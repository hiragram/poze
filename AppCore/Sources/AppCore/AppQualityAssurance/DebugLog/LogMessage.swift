//
//  LogMessage.swift
//  AppQualityAssurance
//
//  Created by Yuya Hirayama on 2022/06/05.
//

import Foundation

public struct LogMessage: ExpressibleByStringInterpolation, CustomStringConvertible {
    public typealias StringLiteralType = String
    public typealias StringInterpolation = LogMessageInterpolation
    
    private let outputString: String
    
    public var description: String {
        outputString
    }
    
    public init(stringLiteral value: String) {
        outputString = value
    }
    
    public init(stringInterpolation: LogMessageInterpolation) {
        outputString = stringInterpolation.outputString
    }
}

public struct LogMessageInterpolation: StringInterpolationProtocol {
    private(set) var outputString: String
    
    public init(literalCapacity: Int, interpolationCount: Int) {
        outputString = ""
    }
    
    mutating public func appendLiteral(_ literal: String) {
        outputString.append(contentsOf: literal)
    }
        
    mutating public func appendInterpolation(_ value: CustomStringConvertible, privacy: Privacy) {
        
        let appendingString: String
        
        switch privacy {
        case .private:
            appendingString = "XXXXXX"
        case .public:
            appendingString = value.description
        }
        
        outputString.append(contentsOf: appendingString)
    }
    
    public typealias StringLiteralType = String
}

extension LogMessageInterpolation {
    public enum Privacy {
        case `public`
        case `private`
    }
}
