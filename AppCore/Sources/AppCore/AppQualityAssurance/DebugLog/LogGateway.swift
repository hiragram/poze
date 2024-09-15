//
//  LogGateway.swift
//  AppQualityAssurance
//
//  Created by hiragram on 2022/12/14.
//

import Foundation

public class LogGateway {
    public static let shared = LogGateway()

    var observers: [LogObserver] = []

    init() {}

    public func add(observer: LogObserver) {
        observers.append(observer)
    }
}

public protocol LogObserver {
    func processLogEvent<Event: CategorizedEvents>(event: Event)
}
