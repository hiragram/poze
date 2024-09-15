//
//  URLRouting.swift
//  AppCore
//
//  Created by hiragram on 2023/01/06.
//

import Foundation

class URLRouter {
    private init() {}

    static let logger = Logger<Event>()

    enum Event: CategorizedEvents {
        static var categoryName: String = "URLRouter"

        case unsupportedScheme(rawURL: URL)
        case unsupportedInAppURLHost(rawURL: URL)

        var eventName: String {
            switch self {
            case .unsupportedInAppURLHost(rawURL: _):
                return "unsupportedInAppURLHost"
            case .unsupportedScheme(rawURL: _):
                return "unsupportedScheme"
            }
        }

        var parameters: [String: CustomStringConvertible] {
            switch self {
            case .unsupportedScheme(rawURL: let url), .unsupportedInAppURLHost(rawURL: let url):
                return [
                    "rawURL": url.absoluteString
                ]
            }
        }

        var logLevel: LogLevel {
            switch self {
            case .unsupportedScheme(rawURL: _):
                return .fault(errorCode: 1)
            case .unsupportedInAppURLHost(rawURL: _):
                return .fault(errorCode: 2)
            }
        }

        var content: LogMessage {
            switch self {
            case .unsupportedScheme(rawURL: let url):
                return "Unsupported scheme: \(url.absoluteString, privacy: .public)"
            case .unsupportedInAppURLHost(rawURL: let url):
                return "Unsupported in-app URL host: \(url.absoluteString, privacy: .public)"
            }
        }
    }

    static func route(url: URL) -> URLRouting? {
        switch url.scheme {
        case "http", "https":
            return .safari(url: url)
        default:
            logger.log(event: .unsupportedScheme(rawURL: url))
            assertionFailure()
            return nil
        }
    }
}

public enum URLRouting: Equatable {
    case safari(url: URL)
    case browserApp(url: URL)
}

private extension Array {
    mutating func removeFirstSafe() -> Element? {
        guard !isEmpty else {
            return nil
        }

        return removeFirst()
    }
}
