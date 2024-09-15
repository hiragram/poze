//
//  File.swift
//  
//
//  Created by Yuya Hirayama on 2024/04/13.
//

import Foundation

class UserDefaultsClient {
    static let shared: UserDefaultsClient = .init(userDefaults: .standard)

    private init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }

    private let userDefaults: UserDefaults

    private let selectedServerEnvironmentIdentifierKey = "selectedServerEnvironmentIdentifier"
    var selectedServerEnvironmentIdentifier: String? {
        get {
            userDefaults.string(forKey: selectedServerEnvironmentIdentifierKey)
        }

        set {
            userDefaults.setValue(newValue, forKey: selectedServerEnvironmentIdentifierKey)
        }
    }
}
