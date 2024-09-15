//
//  Screen+PVLog.swift
//  AppCore
//
//  Created by hiragram on 2022/12/11.
//

import SwiftUI

class ScreenPVLog {
    fileprivate static let shared = ScreenPVLog()

    private init() {

    }

    let logger = Logger<Event>()

    enum Event: CategorizedEvents {
        static let categoryName: String = "ScreenPVLog"

        case appear(screenType: any Screen.Type)

        var eventName: String {
            switch self {
            case .appear:
                return "appear"
            }
        }

        var parameters: [String : CustomStringConvertible] {
            switch self {
            case .appear(screenType: let screenType):
                return [
                    "screenType": String(describing: screenType),
                ]
            }
        }

        var logLevel: LogLevel {
            switch self {
            case .appear:
                return .notice
            }
        }

        var content: LogMessage {
            switch self {
            case .appear(screenType: let screenType):
                let rawScreenName = String(describing: screenType)

                return "\(rawScreenName, privacy: .public)"
            }
        }
    }
}

extension View where Self: Screen {
    func pvLog() -> some View {
        self.onAppear {
            ScreenPVLog.shared.logger.log(event: .appear(screenType: Self.self))
        }
    }
}
