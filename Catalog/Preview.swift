//
//  Preview.swift
//  Catalog
//
//  Created by Yuya Hirayama on 2023/11/26.
//

import Foundation
import SwiftUI

struct Preview: Identifiable {
    var id: String { name }
    
    var name: String
    var view: AnyView
}
