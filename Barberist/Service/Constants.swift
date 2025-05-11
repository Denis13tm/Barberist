//
//  Constants.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/9/25.
//

import SwiftUI

class Constants {
    static let defaultLanguage = "uz"
    static let defaultCurrency = Currency.uzs
    static let defaultCountryCode = "+998"
    static let contactUsUrl = "contact url"
    static let instagramUrl = "instagram url"
    static let telegramUrl = "telegram url"
    static let premiumUrl = "url"
    static let accentColorHex = "YOUR_API_KEY_HERE"
}

enum Currency: ConvertableEnum, CaseIterable, Codable, Equatable, Hashable {
    
    static var allCases: [Currency] = [.uzs, .usd]
    
    case uzs, usd
    case custom(String)
    
    init?(rawValue: String) {
        if let match = Currency.allCases.first(where: { $0.rawValue.lowercased() == rawValue.lowercased() }) {
            self = match
        } else {
            self = .custom(rawValue)
        }
    }
    
    init(dynamicRawValue: String) {
        self = Currency(rawValue: dynamicRawValue) ?? .custom(dynamicRawValue)
    }
    
    var rawValue: String {
        switch self {
        case .uzs:
            return "UZS"
        case .usd:
            return "USD"
        case .custom(let string):
            return string
        }
    }
    
//    var text: Text { Text(LocalizedStringKey(rawValue), tableName: Localizations.gearboxTyoes.rawValue) }
//    var value: String { rawValue.localizedString(identifier: Utils.getCurrentLanguage(), table: .gearboxTypes) }
    
}

protocol ConvertableEnum : Codable, Equatable {
    init?(rawValue: String) // Optional exact match
    init(dynamicRawValue: String) // Required: handles unknown values
    var rawValue: String { get }
}

extension ConvertableEnum {
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        self = Self(dynamicRawValue: raw)
    }
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

struct Language: Identifiable {
    let id = UUID()
    let name: String
    let identifier: String
}
