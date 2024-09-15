//
//  File.swift
//  
//
//  Created by Yuya Hirayama on 2023/11/29.
//

import UIKit
import AppCore
import AppRepository

extension SceneDelegate {
    @MainActor func updateRootVC(_ rootVC: RootViewController) {
        let preferred = RootVCSelection.shared.preferredRootVC

        rootVC.dismiss(animated: true)

        let contentVC: UIViewController
        
        switch preferred {
        case .main:
            let vc = UIViewController()
            vc.view.backgroundColor = .red

            contentVC = vc
        }
        rootVC.setContent(contentVC)
    }

}
