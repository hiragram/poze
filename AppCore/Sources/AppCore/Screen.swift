//
//  Screen.swift
//  AppCore
//
//  Created by Yuya Hirayama on 2022/04/03.
//

import Foundation
import UIKit
import SwiftUI

public protocol Screen {
    associatedtype Presenter: PresenterProtocol
    associatedtype Event: CategorizedEvents

    var presenter: Presenter { get }
    var logger: Logger<Event> { get }

    static var standardTabBarAppearance: UITabBarAppearance? { get }
    static var scrollEdgeTabBarAppearance: UITabBarAppearance? { get }
}

public protocol VIPERScreen: Screen {
    init(presenter: Presenter)
}

public extension Screen {
    static var standardTabBarAppearance: UITabBarAppearance? {
        nil
    }
    
    static var scrollEdgeTabBarAppearance: UITabBarAppearance? {
        nil
    }
}

public extension VIPERScreen where Self: View {
    @ViewBuilder func section<V: View>(title: LocalizedStringResource, content: () -> V) -> some View {
        Section(
            content: content,
            header: {
                Text(title)
                    .font(.title.bold())
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                    .padding(.top)
            }
        )
    }
}
