//
//  Router.swift
//  AppCore
//
//  Created by Yuya Hirayama on 2022/04/03.
//

import Foundation
import UIKit
import SafariServices
import SwiftUI
import PhotosUI
import StoreKit

@MainActor public protocol RouterProtocol: AnyObject {
    var viewController: UIViewController? { get set }
}

class RouterLogger {
    static let logger: Logger<Event> = .init()

    enum Event: CategorizedEvents {
        case notImplementedDialogShown(featureName: String)
        case triedToOpenUnsupportedURL(urlString: String)

        static var categoryName: String = "RouterLogger"

        var eventName: String {
            switch self {
            case .notImplementedDialogShown:
                return "notImplementedDialogShown"
            case .triedToOpenUnsupportedURL:
                return "triedToOpenUnsupportedURL"
            }
        }

        var parameters: [String: CustomStringConvertible] {
            switch self {
            case .notImplementedDialogShown:
                return [:]
            case .triedToOpenUnsupportedURL(urlString: let urlString):
                return [
                    "urlString": urlString,
                ]
            }
        }

        var logLevel: LogLevel {
            switch self {
            case .notImplementedDialogShown:
                return .fault(errorCode: 1)
            case .triedToOpenUnsupportedURL:
                return .fault(errorCode: 2)
            }
        }

        var content: LogMessage {
            switch self {
            case .notImplementedDialogShown(featureName: let featureName):
                return "[Not implemented] \(featureName, privacy: .public) is not implemented."
            case .triedToOpenUnsupportedURL(urlString: let urlString):
                return "[Not supported] tried to open \"\(urlString, privacy: .public)\""
            }
        }
    }
}

public extension RouterProtocol {
    func showAlert(alert: UIAlertController) {
        viewController?.present(alert, animated: true)
    }

    func showError(_ error: Error) {
        print("showError", error)
        guard !Task.isCancelled else {
            return
        }
        
        Task {
            await MainActor.run {
                showSimpleError(error)
            }
        }
    }

    @MainActor private func showSimpleError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .default)

        alert.addAction(ok)

        viewController?.present(alert, animated: true)
    }

    func open(urlRouting: URLRouting) {
        let destination: UIViewController
        switch urlRouting {
        case .safari(url: let url):
            destination = SFSafariViewController(url: url)
        case .browserApp(url: let url):
            UIApplication.shared.open(url)
            return
        }

        viewController?.present(destination, animated: true)
    }

    func open(url: URL) {
        if let routing = URLRouter.route(url: url) {
            self.open(urlRouting: routing)
        }
    }

    func dismiss() {
        viewController?.dismiss(animated: true)
    }


    func requestAppStoreReview() {
        guard let scene = viewController?.view.window?.windowScene else {
            return
        }
        SKStoreReviewController.requestReview(in: scene)
    }

}
