//
//  InAppEventNotificationBanner.swift
//
//  Created by hiragram on 2023/02/09.
//

import SwiftUI

struct InAppEventNotificationBanner: View {
    var text: Text
    var eventType: InAppEvent.EventType

    var body: some View {
        HStack {
            eventType.iconImage
            text
            Spacer()
        }
        .font(.system(size: 17).bold())
        .foregroundColor(eventType.textColor)
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(eventType.bannerColor)
        }
        .padding(.horizontal, 4)
    }
}

struct InAppEventNotificationBanner_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            InAppEventNotificationBanner(
                text: Text("なんかの通知だよ〜"),
                eventType: .notice
            )
            InAppEventNotificationBanner(
                text: Text("完了したぞ"),
                eventType: .success
            )
            InAppEventNotificationBanner(
                text: Text("ミスったぞ"),
                eventType: .fail
            )
            Spacer()
        }
    }
}
