//
//  ViewConstructor.swift
//  AppCore
//
//  Created by Yuya Hirayama on 2022/04/03.
//

import Foundation
import UIKit
import SwiftUI

@MainActor final public class ViewConstructor {
    public static func build<V: SwiftUI.View & VIPERScreen>(_ screenType: V.Type, presenter: V.Presenter, embedInNavigationStack: Bool = false) -> UIViewController {

        let view: any View
        if embedInNavigationStack {
            view = NavigationStack {
                V(presenter: presenter).pvLog()
            }
        } else {
            view = V(presenter: presenter).pvLog()
        }

        let host = UIHostingController(rootView: AnyView(view))
        presenter.router.viewController = host

        return host
    }
}
