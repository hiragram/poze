//
//  LocalizedStringDataModel.swift
//  AppCore
//
//  Created by hiragram on 2022/10/24.
//

import Foundation

public struct LocalizedData<T: Sendable>: Sendable {
    var en: T
    var ja: T

    public init(en: T, ja: T) {
        self.en = en
        self.ja = ja
    }

    public var localized: T {
        fatalError()
//        switch Localization.metaLanguageCode.localizedString {
//        case "en":
//            return en
//        case "ja":
//            return ja
//        default:
//            return en
//        }
    }
}

public extension LocalizedData where T == String {
    var localizedString: String {
        localized
    }
}
