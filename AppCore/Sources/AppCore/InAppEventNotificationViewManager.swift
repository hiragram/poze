//
//  InAppEventNotificationViewManager.swift
//  AppCore
//
//  Created by hiragram on 2023/02/09.
//

import Foundation
import SwiftUI

public protocol InAppEventNotificationViewManagerProtocol: ObservableObject {
    var currentEvent: InAppEvent? { get }
}

public struct InAppEvent: Sendable {
    public var id: UUID
    public var text: String
    public var type: EventType
    public var duration: TimeInterval

    public init(id: UUID, text: String, type: EventType, duration: TimeInterval = 5) {
        self.id = id
        self.text = text
        self.type = type
        self.duration = duration
    }

    public enum EventType: String, Sendable {
        case notice
        case success
        case fail

        var bannerColor: Color {
            switch self {
            case .notice:
                return .gray
            case .success:
                return .green
            case .fail:
                return .red
            }
        }

        var textColor: Color {
            switch self {
            case .notice:
                return .black
            case .fail, .success:
                return .white
            }
        }

        @ViewBuilder var iconImage: some View {
            switch self {
            case .success:
                Image(systemName: "checkmark.circle")
            case .fail:
                Image(systemName: "exclamationmark.octagon")
            case .notice:
                EmptyView()
            }
        }
    }

}
