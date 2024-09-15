//
//  AppDelegate.swift
//  App
//
//  Created by hiragram on 2023/10/02.
//

import UIKit
import AppCore
import AppTrackingTransparency
import AVFoundation

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

        do {
            let quickMenuItems = [
                createQuickMenuForDebugMenu()
            ]
                .compactMap { $0 }

            UIApplication.shared.shortcutItems = quickMenuItems
        }

        do {
            initializeFirebase()
        }

        do {
            setupLogGateway()
        }

        do {
            Task {
                try? await Task.sleep(for: .seconds(5))
                await ATTrackingManager.requestTrackingAuthorization()
            }
        }

        do {
            AppStoreManager.shared.startObservingTransactionUpdates()
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .moviePlayback, options: [])
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Audio session setup error: \(error)")
        }

        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    private func createQuickMenuForDebugMenu() -> UIApplicationShortcutItem? {
        switch BuildConfiguration.current {
        case .debug:
            let icon = UIApplicationShortcutIcon(systemImageName: "gearshape")
            let shortcutItem = UIApplicationShortcutItem(
                type: QuickMenuItem.openDebugMenu.rawValue,
                localizedTitle: "デバッグメニュー",
                localizedSubtitle: "開く",
                icon: icon
            )

            return shortcutItem
        case .release:
            return nil
        }
    }

    private enum QuickMenuItem: String {
        case openDebugMenu
    }
}

