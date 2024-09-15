import UIKit
import SwiftUI
import AppQualityAssurance

@MainActor protocol DummyScreenRouterProtocol: RouterProtocol {

}

@MainActor final class DummyScreenRouter: DummyScreenRouterProtocol {
    weak var viewController: UIViewController?
    let logger = Logger<Event>()

    enum Event: CategorizedEvents {
        static var categoryName: String {
            "DummyScreen_Router"
        }

        var eventName: String {
            fatalError()
        }

        var parameters: [String: CustomStringConvertible] {
            fatalError()
        }

        var logLevel: LogLevel {
            fatalError()
        }

        var content: LogMessage {
            fatalError()
        }
    }
}

@MainActor final class MockDummyScreenRouter: DummyScreenRouterProtocol {
    weak var viewController: UIViewController?
}
