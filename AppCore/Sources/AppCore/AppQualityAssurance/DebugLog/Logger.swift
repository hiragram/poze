//
//  Logger.swift
//  AppQualityAssurance
//
//  Created by Yuya Hirayama on 2022/06/05.
//

import Foundation
import os

let subsystemName = "app.hiragram.AppQualityAssurance"

final public class Logger<Event: CategorizedEvents> {
    private let osLogger: os.Logger

    private let logGateway: LogGateway = .shared

    public init() {
        osLogger = .init(subsystem: subsystemName, category: "\(Event.categoryName)")
    }
    
    public func log(event: Event) {
        switch event.logLevel {
        case .debug:
            osLogger.debug("\(event.content, privacy: .public)")
        case .info:
            osLogger.info("\(event.content, privacy: .public)")
        case .notice:
            osLogger.notice("\(event.content, privacy: .public)")
        case .error:
            osLogger.error("\(event.content, privacy: .public)")
        case .fault(errorCode: _):
            osLogger.error("\(event.content, privacy: .public)")
        }

        logGateway.observers.forEach { observer in
            observer.processLogEvent(event: event)
        }
    }
}
