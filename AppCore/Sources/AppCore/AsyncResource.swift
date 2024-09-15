//
//  AsyncResource.swift
//  AppCore
//
//  Created by Yuya Hirayama on 2022/03/21.
//

import Foundation

public enum AsyncResource<T> {
    case uninitialized
    case received(T)

    public var value: T? {
        switch self {
        case .received(let value):
            return value
        case .uninitialized:
            return nil
        }
    }

    public var isUninitialized: Bool {
        switch self {
        case .uninitialized:
            return true
        case .received:
            return false
        }
    }

    public func map<R>(_ block: (T) throws -> R) rethrows -> AsyncResource<R> {
        if let value {
            return .received(try block(value))
        } else {
            return .uninitialized
        }
    }
}
