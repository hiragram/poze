//
//  InAppEventNotificationManager.swift
//  AppCore
//
//  Created by hiragram on 2023/02/09.
//

import Foundation
import SwiftUI

final public class InAppEventNotificationViewManager: InAppEventNotificationViewManagerProtocol, ObservableObject {
    public static let shared = InAppEventNotificationViewManager()

    private let logger = Logger<Event>()

    enum Event: CategorizedEvents {
        static var categoryName: String {
            "InAppEventNotificationViewManager"
        }

        case eventIsRequestedToShow(event: InAppEvent)
        case eventIsActuallyShown(event: InAppEvent)
        case eventIsActuallyDismissed(event: InAppEvent)

        var eventName: String {
            switch self {
            case .eventIsRequestedToShow:
                return "eventIsRequestedToShow"
            case .eventIsActuallyShown:
                return "eventIsActuallyShown"
            case .eventIsActuallyDismissed:
                return "eventIsActuallyDismissed"
            }
        }

        var parameters: [String: CustomStringConvertible] {
            switch self {
            case .eventIsRequestedToShow(event: let event),
                    .eventIsActuallyShown(event: let event),
                    .eventIsActuallyDismissed(event: let event):
                return [
                    "eventID": event.id,
                    "text": event.text,
                    "type": event.type.rawValue,
                ]
            }
        }

        var logLevel: LogLevel {
            switch self {
            default:
                return .info
            }
        }

        var content: LogMessage {
            switch self {
            case .eventIsRequestedToShow(event: let event):
                return "Event is requested to show. ID: \(event.id.uuidString, privacy: .public), Text: \(event.text, privacy: .public), Type: \(event.type.rawValue, privacy: .public)"
            case .eventIsActuallyShown(event: let event):
                return "Event is actually shown. ID: \(event.id.uuidString, privacy: .public), Text: \(event.text, privacy: .public), Type: \(event.type.rawValue, privacy: .public)"
            case .eventIsActuallyDismissed(event: let event):
                return "Event is actually dismisse. ID: \(event.id.uuidString, privacy: .public), Text: \(event.text, privacy: .public), Type: \(event.type.rawValue, privacy: .public)"
            }
        }

    }

    @MainActor @Published public var currentEvent: InAppEvent?

    public func requestShow(event: InAppEvent) {
        logger.log(event: .eventIsRequestedToShow(event: event))
        Task {
            await self.show(event: event)
        }
    }

    private var currentEventTask: Task<Void, Never>?

    private func show(event: InAppEvent) async {
        logger.log(event: .eventIsActuallyShown(event: event))
        currentEventTask = Task { @MainActor in
            currentEvent = event

            try? await Task.sleep(nanoseconds: UInt64(Int(event.duration * Double(NSEC_PER_SEC))))

            dismissCurrentEventIfMatch(id: event.id)

            try? await Task.sleep(nanoseconds: 5 * NSEC_PER_SEC / 10)
        }
    }

    @MainActor func dismissCurrentEventIfMatch(id: UUID) {
        guard let currentEvent else {
            return
        }

        guard currentEvent.id == id else {
            return
        }

        logger.log(event: .eventIsActuallyDismissed(event: currentEvent))
        self.currentEvent = nil
    }

    @MainActor func updateCurrentEventIfMatch(id: UUID, block: (InAppEvent) -> InAppEvent) {
        if let currentEvent, currentEvent.id == id {
            let newEvent = block(currentEvent)
            if self.currentEvent?.id == id {
                self.currentEvent = newEvent
            }
        }
    }
}
