//
//  File.swift
//  
//
//  Created by Yuya Hirayama on 2024/05/12.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseAnalyticsSwift

class FirebaseLogObserver: LogObserver {
    func processLogEvent<Event>(event: Event) where Event : CategorizedEvents {

        let firebaseEventType: String
        let parameters: [String: Any]
        switch event {
        case .appear(screenType: let screenType) as ScreenPVLog.Event:
            firebaseEventType = AnalyticsEventScreenView
            parameters = [
                AnalyticsParameterScreenName: String(describing: screenType),
            ]
        default:
            firebaseEventType = String("\(event.categoryName)_\(event.eventName)".prefix(25))
            parameters = event.parameters
        }

        Analytics.logEvent(firebaseEventType, parameters: parameters)
    }
}
