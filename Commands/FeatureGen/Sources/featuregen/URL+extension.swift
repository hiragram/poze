//
//  File.swift
//  
//
//  Created by hiragram on 2023/09/30.
//

import Foundation

extension URL {
    var contentString: String {
        get throws {
            String(data: try Data(contentsOf: self), encoding: .utf8)!
        }
    }
}
