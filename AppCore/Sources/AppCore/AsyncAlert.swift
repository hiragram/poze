//
//  AsyncAlert.swift
//  AppCore
//
//  Created by hiragram on 2023/05/09.
//

import Foundation
import UIKit

protocol AsyncAlertOption {
    var buttonTitle: String { get }
    var style: UIAlertAction.Style { get }
}

extension RouterProtocol {
    func userSelection<Option: AsyncAlertOption>(title: String?, body: String?, style: UIAlertController.Style, options: [Option]) async -> Option {
        await withCheckedContinuation({ [weak viewController] continuation in
            Task { @MainActor in
                let alert = UIAlertController(title: title, message: body, preferredStyle: style)

                options.map { option in
                    UIAlertAction(title: option.buttonTitle, style: option.style) { _ in
                        continuation.resume(returning: option)
                    }
                }
                .forEach { action in
                    alert.addAction(action)
                }

                viewController?.present(alert, animated: true)
            }
        })
    }
}
