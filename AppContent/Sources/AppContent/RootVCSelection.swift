//
//  File.swift
//  
//
//  Created by Yuya Hirayama on 2023/11/29.
//

import Foundation
import AppCore

@Observable class RootVCSelection {
    public static let shared = RootVCSelection()

    var preferredRootVC: RootVCType {
        .main
    }
}

enum RootVCType: Equatable {
    case main
}
