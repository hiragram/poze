//
//  RootViewController.swift
//  AppCore
//
//  Created by Yuya Hirayama on 2022/03/22.
//

import UIKit

final public class RootViewController: UIViewController {
    private var contentVC: UIViewController? = nil

    private(set) lazy var router: RootVCRouter = .init(viewController: self)

    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        if contentVC != nil {
            addContentVCToHierarchy()
        }
    }

    @MainActor public func setContent(_ vc: UIViewController) {
        UIView.animate(
            withDuration: 0.3,
            delay: 0,
            options: [.curveEaseInOut],
            animations: { [contentVC] in
                contentVC?.view.alpha = 0
            },
            completion: { [weak self] _ in
                guard let _self = self else {
                    return
                }

                _self.contentVC = vc

                if _self.isViewLoaded {
                    _self.addContentVCToHierarchy()
                }
            }
        )
    }
    
    private func addContentVCToHierarchy() {
        guard let contentVC = contentVC else {
            preconditionFailure("self.contentVC must be set before calling addContentVCToHierarchy .")
        }
        view.insertSubview(contentVC.view, at: 0)
        contentVC.view.translatesAutoresizingMaskIntoConstraints = false
        
        view.addConstraints([
            view.topAnchor.constraint(equalTo: contentVC.view.topAnchor),
            view.bottomAnchor.constraint(equalTo: contentVC.view.bottomAnchor),
            view.leftAnchor.constraint(equalTo: contentVC.view.leftAnchor),
            view.rightAnchor.constraint(equalTo: contentVC.view.rightAnchor),
        ])

        self.addChild(contentVC)
        contentVC.didMove(toParent: self)
        contentVC.view.setNeedsLayout()
    }
}

final class RootVCRouter: RouterProtocol {
    weak var viewController: UIViewController?

    init(viewController: UIViewController?) {
        self.viewController = viewController
    }
}

//extension UIViewController {
//    @available(*, unavailable)
//    var appRootViewController: RootViewController? {
//        RootViewController.appRootViewController()
//    }
//}
