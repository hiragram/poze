//
//  File.swift
//  
//
//  Created by Yuya Hirayama on 2024/05/18.
//

import Foundation
import StoreKit

@Observable public class AppStoreManager {
    public static let shared = AppStoreManager()

    private init() {
        Task {
            await updateSubscriptionStatus()
        }
    }

    private func updateSubscriptionStatus() async {
        var monthlyPlanSubscribed = false
        var annualPlanSubscribed = false
        for await result in Transaction.currentEntitlements {
            switch result {
//            case .verified(let transaction) where transaction.productID == paidPlan1MonthProductID:
//                monthlyPlanSubscribed = true
//            case .verified(let transaction) where transaction.productID == paidPlan1YearProductID:
//                annualPlanSubscribed = true
            default:
                break
            }
        }

        paidPlanSubscription = .received(monthlyPlanSubscribed ? .monthly : annualPlanSubscribed ? .annual : nil)
        paidPlanLifetimeAccess = .received(false)
    }

    public enum PaidPlanPeriod {
        case monthly
        case annual
    }

    public private(set) var paidPlanSubscription: AsyncResource<PaidPlanPeriod?> = .uninitialized
    public private(set) var paidPlanLifetimeAccess: AsyncResource<Bool> = .uninitialized

    public var isPaidPlanActive: AsyncResource<Bool> {
        switch BuildConfiguration.current {
        case .debug:
            return .received(true)
        case .release:
            switch (paidPlanSubscription, paidPlanLifetimeAccess) {
            case (.received(.some(_)), _):
                return .received(true)
            case (_, .received(true)):
                return .received(true)
            case (.uninitialized, _), (_, .uninitialized):
                return .uninitialized
            default:
                return .received(false)
            }
        }
    }

//    private let paidPlan1MonthProductID = "app.turnmark.premium.1month"
//    private let paidPlan1YearProductID = "app.turnmark.premium.1year"

//    public func paidPlan1Month() async throws -> Product {
//        try await product(productID: paidPlan1MonthProductID)
//    }

//    public func paidPlan1Year() async throws -> Product {
//        try await product(productID: paidPlan1YearProductID)
//    }

    private func product(productID: String) async throws -> Product {
        guard let product = try await Product.products(for: [productID]).first else {
            throw AppStoreManagerError.productNotFound(id: productID)
        }

        return product
    }

    public enum AppStoreManagerError: Error {
        case productNotFound(id: String)
    }

//    public func subscribeMonthlyPaidPlan() async throws {
//        let result = try await paidPlan1Month().purchase()
//
//        print(result)
//        await updateSubscriptionStatus()
//    }

//    public func subscribeAnnualPaidPlan() async throws {
//        let result = try await paidPlan1Year().purchase()
//
//        print(result)
//        await updateSubscriptionStatus()
//    }

    public func startObservingTransactionUpdates() {
        Task(priority: .background) {
            for await _ in Transaction.updates {
                await updateSubscriptionStatus()
            }
        }
    }

    public func syncToAppStore() async throws {
        try await AppStore.sync()

        await updateSubscriptionStatus()
    }
}
