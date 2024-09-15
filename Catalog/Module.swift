//
//  Module.swift
//  Catalog
//
//  Created by Yuya Hirayama on 2023/11/26.
//

import Foundation

struct Module: Identifiable {
    var id: String { name }
    
    var name: String
    var screens: [Screen]
}
