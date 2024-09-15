//
//  File.swift
//  
//
//  Created by Yuya Hirayama on 2024/04/29.
//

import Foundation

public enum BuildConfiguration {
    case debug
    case release

    public static var current: BuildConfiguration {
        #if Debug
        return .debug
        #else
        return .release
        #endif
    }
}
