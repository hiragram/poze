//
//  ScreenHostingController.swift
//  AppCore
//
//  Created by Yuya Hirayama on 2022/04/04.
//

import UIKit
import SwiftUI

@available(*, deprecated)
final class ScreenHostingController<Content: View & Screen>: UIViewController, UIViewControllerTransitioningDelegate {

    deinit {
        onDeinit()
    }

    private var formerStandardAppearance: UITabBarAppearance?
    private var formerScrollEdgeAppearance: UITabBarAppearance?

    private let statusBarStyle: UIStatusBarStyle

    private let onDeinit: () -> Void
    
    private let hostingController: UIViewController

    init(rootView: Content, preferredStatusBarStyle: UIStatusBarStyle = .default, onDeinit: @escaping () -> Void = {}) {
        self.onDeinit = onDeinit
        statusBarStyle = preferredStatusBarStyle
        hostingController = UIHostingController(rootView: AnyView(rootView.pvLog()))
        super.init(nibName: nil, bundle: nil)
        rootView.presenter.router.viewController = self
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        statusBarStyle
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.backButtonDisplayMode = .minimal

        addChild(hostingController)

        view.addSubview(hostingController.view)
        
        hostingController.view.translatesAutoresizingMaskIntoConstraints = false

        view.addConstraints([
            view.topAnchor.constraint(equalTo: hostingController.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: hostingController.view.bottomAnchor),
            view.leftAnchor.constraint(equalTo: hostingController.view.leftAnchor),
            view.rightAnchor.constraint(equalTo: hostingController.view.rightAnchor),
        ])

        hostingController.didMove(toParent: self)
    }

    var customPresentationController: ((UIViewController, UIViewController?) -> UIPresentationController?)?

    @objc func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        customPresentationController?(presented, presenting)
    }
}

