//
//  InAppEventNotificationView.swift
//
//  Created by hiragram on 2023/02/09.
//

import SwiftUI

public struct InAppEventNotificationView<Manager: InAppEventNotificationViewManagerProtocol>: View {
    @ObservedObject var manager: Manager

    public init(manager: Manager) {
        self.manager = manager
    }

    public var body: some View {
        VStack {
            Group {
                if let event = manager.currentEvent {
                    InAppEventNotificationBanner(
                        text: Text("\(event.text)"),
                        eventType: event.type
                    )
                    .compositingGroup()
                }
            }
            .animation(.easeInOut(duration: 0.3), value: manager.currentEvent?.id)
            .transition(.offset(y: -100))

            Spacer()
        }
        .shadow(radius: 4)
    }
}

struct InAppEventNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        InAppEventNotificationView(manager: MockManager(event: .init(id: .init(), text: "通知だよ", type: .notice)))
    }
}

private class MockManager: InAppEventNotificationViewManagerProtocol {
    @Published var currentEvent: InAppEvent?

    init(event: InAppEvent?) {
        self.currentEvent = event
    }
}
