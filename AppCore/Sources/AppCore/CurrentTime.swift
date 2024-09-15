//
//  File.swift
//  
//
//  Created by Yuya Hirayama on 2024/04/15.
//

import Foundation
import Combine

@Observable final public class CurrentTime {
    public static let shared = CurrentTime(now: .now)

    private(set) public var now: Date

    private var timerSubscription: AnyCancellable?

    private init(now: Date) {
        self.now = now

        timerSubscription = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { newNow in
                self.now = newNow
            }
    }
}
