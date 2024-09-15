//
//  TabItem.swift
//  AppCore
//
//  Created by hiragram on 2022/12/02.
//

import SwiftUI
import UIKit

public struct BuiltView: UIViewControllerRepresentable {
    let view: () -> UIViewController

    public init(view: @escaping () -> UIViewController) {
        self.view = view
    }

    public func makeUIViewController(context: Context) -> some UIViewController {
        view()
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}
