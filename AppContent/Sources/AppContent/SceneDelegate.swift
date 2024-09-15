//
//  SceneDelegate.swift
//
//  Created by Yuya Hirayama on 2022/03/05.
//

import UIKit
import SwiftUI
import AppTrackingTransparency
import AppCore
import AppRepository

open class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    public var window: UIWindow?

    private var lastRootVCSelection: RootVCType?

    private var inAppEventBannerWindow: UIWindow?
    private var serverEnvironmentLabelWindow: UIWindow?
    private var eventLogOverlayWindow: UIWindow?

    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowScene = windowScene
        let rootVC = RootViewController()
        window.rootViewController = rootVC
        window.makeKeyAndVisible()
        self.window = window

        do {
            inAppEventBannerWindow = addInAppEventBannerWindow(scene: windowScene)
        }

        if let userActivity = connectionOptions.userActivities.first(where: { $0.webpageURL != nil }) {
            Task {
                try? await Task.sleep(nanoseconds: 2 * NSEC_PER_SEC)
                handleUserActivity(userActivity: userActivity)
            }
        }

        rootVCSelectionChangeHandler = RootVCSelection.shared.observeChange(keyPath: \.preferredRootVC) { [weak self] newValue in
            guard self?.lastRootVCSelection != newValue else {
                return
            }

            self?.lastRootVCSelection = newValue
            self?.updateRootVC(rootVC)
        }
    }

    private var rootVCSelectionChangeHandler: Any?


    func handleUserActivity(userActivity: NSUserActivity) {
//        if userActivity.activityType == NSUserActivityTypeBrowsingWeb, let webURL = userActivity.webpageURL {
//        }
    }

    public func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        handleUserActivity(userActivity: userActivity)
    }

    private func addInAppEventBannerWindow(scene: UIWindowScene) -> UIWindow {
        let window = UIWindow(windowScene: scene)
        window.windowLevel = .alert - 1
        window.isHidden = false
        window.makeKeyAndVisible()
        window.isUserInteractionEnabled = false

        do {
            let view = InAppEventNotificationView(manager: InAppEventNotificationViewManager.shared)

            let vc = UIHostingController(rootView: view)
            vc.view.backgroundColor = .clear
            window.rootViewController = vc
        }

        return window
    }

    public func windowScene(_ windowScene: UIWindowScene, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        switch QuickMenuItem(rawValue: shortcutItem.type) {
        case .none:
            completionHandler(false)
        case .openDebugMenu:
//            let debugVC = ViewConstructor.build(
//                Debug.self,
//                presenter: DebugPresenter(
//                    interactor: DebugInteractor(),
//                    router: DebugRouter()
//                )
//            )
//                .embedInNavigationController()
//
//            RootViewController.appRootViewController()?.present(debugVC, animated: true)
//            completionHandler(true)
            break
        }
    }

    public func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
//        guard let url = URLContexts.first?.url else {
//            return
//        }
    }

    public func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    public func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    public func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    public func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    public func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

public extension RootViewController {
    static func appRootViewController() -> RootViewController? {
        guard let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate else {
            return nil
        }

        let result = sceneDelegate.window?.rootViewController as! RootViewController

        return result
    }
}

public enum QuickMenuItem: String {
    case openDebugMenu
}
