//
//  UIViewController+extension.swift
//  AppCore
//
//  Created by Yuya Hirayama on 2022/03/22.
//

import UIKit

public extension UIViewController {
    func embedInNavigationController(statusBarStyle: UIStatusBarStyle = .default) -> UINavigationController {
        UINavigationController(rootViewController: self)
    }
}
