//
//  File.swift
//  
//
//  Created by Yuya Hirayama on 2024/05/12.
//

import UIKit
import Firebase
import FirebaseCore

public extension UIApplicationDelegate {
    func initializeFirebase() {
        FirebaseApp.configure()

        switch BuildConfiguration.current {
        case .debug:
            Analytics.setAnalyticsCollectionEnabled(false)
        case .release:
            Analytics.setAnalyticsCollectionEnabled(true)
        }
    }

    func setupLogGateway() {
        LogGateway.shared.add(observer: FirebaseLogObserver())
    }
}
