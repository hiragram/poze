//
//  TerminationStatus.swift
//  AppCore
//
//  Created by Yuya Hirayama on 2022/06/05.
//

import Foundation

final public class TerminationStatus {
    public static let shared: TerminationStatus = .init(
        defaults: .standard
    )
    static let abnormalTerminationFlagKey = "abnormal_termination"

    private let defaults: UserDefaults
    
    init(defaults: UserDefaults) {
        self.defaults = defaults
    }
    
    public func markLaunched() {
        defaults.set(true, forKey: Self.abnormalTerminationFlagKey)
    }
    
    public func markTerminationCorrectly() {
        defaults.set(false, forKey: Self.abnormalTerminationFlagKey)
    }
    
    public func getLastTerminationWasAbnormal() -> Bool {
        defaults.bool(forKey: Self.abnormalTerminationFlagKey)
    }
}
