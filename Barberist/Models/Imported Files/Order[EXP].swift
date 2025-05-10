//
//  Shops.swift
//  Barberist
//
//  Created by Shohjahon Rakhmatov on 28/04/25.
//

import SwiftUI

//struct Order: Identifiable, Hashable {
//    
//    var id: String?
//    var image: String?
//    var name: String?
//    var status: Status?
//    var services: [Service]?
//    var scheduledTime: Int?
//    
//    var price: String? {
//        guard let services = services else { return nil }
//        var filteredServices: [Currency: [Service]] = [:]
//        for service in services {
//            if let currency = service.currency {
//                filteredServices[currency] = (filteredServices[currency] ?? [])
//                filteredServices[currency]?.append(service)
//            }
//        }
//        return filteredServices.map { service in
//            let totalPrice = service.value.reduce(0, { $0 + ($1.price ?? 0) })
//            return "\(totalPrice.formatted()) \(service.key.value)"
//        }
//        .joined(separator: ", ")
//    }
//    
//    enum Status: String {
//        
//        case active = "active"
//        case cancelled = "cancelled"
//        case successful = "successful"
//        
//        var title: LocalizedStringKey {
//            switch self {
//            case .active:
//                return "Active"
//            case .cancelled:
//                return "Cancelled"
//            case .successful:
//                return "Successful"
//            }
//        }
//        
//        var color: Color {
//            switch self {
//            case .active:
//                return .accentColor
//            case .cancelled:
//                return .red
//            case .successful:
//                return .green
//            }
//        }
//    }
//    
//    init(id: String? = nil, image: String? = nil, name: String? = nil, status: Status? = nil, services: [Service]? = nil, scheduledTime: Int? = nil) {
//        self.id = id
//        self.image = image
//        self.name = name
//        self.status = status
//        self.services = services
//        self.scheduledTime = scheduledTime
//    }
//    
//    static var mock = Order(id: UUID().uuidString, image: "https://images.newrepublic.com/9bba0e56c589fb3e06191969202abb446327a86a.jpeg?auto=format&fit=crop&crop=faces&q=65&w=1000&ar=3%3A2&ixlib=react-9.10.0", name: "John Doe", status: .active, services: Service.mocks, scheduledTime: 1746105429)
//    static var mock2 = Order(id: UUID().uuidString, image: "https://images.newrepublic.com/9bba0e56c589fb3e06191969202abb446327a86a.jpeg?auto=format&fit=crop&crop=faces&q=65&w=1000&ar=3%3A2&ixlib=react-9.10.0", name: "John Doe", status: .active, services: Service.mocks, scheduledTime: 1746030309)
//    static var mock3 = Order(id: UUID().uuidString, image: nil, name: "John Doe", status: .active, services: Service.mocks, scheduledTime: 1746030309)
//    
//    var scheduledDate: String? {
//        guard let scheduledTime else { return nil }
//        let date = Date(timeIntervalSince1970: TimeInterval(scheduledTime))
//        let appLanguage = UserDefaults.standard.string(forKey: AppStorageKeys.appLanguage) ?? Constants.defaultLanguage
//        let calendar = Calendar.current
//        let now = Date()
//        
//        let dateFormatter = DateFormatter()
//        dateFormatter.locale = Locale(identifier: appLanguage)
//        
//        if calendar.isDateInToday(date) {
//            dateFormatter.timeStyle = .short
//            dateFormatter.dateStyle = .none
//            return dateFormatter.string(from: date)
//        } else if calendar.isDateInYesterday(date) {
//            return LocalizedStringKey("Yesterday").localizedString(identifier: appLanguage)
//        } else if calendar.isDateInTomorrow(date) {
//            dateFormatter.timeStyle = .short
//            dateFormatter.dateStyle = .none
//            let timeString = dateFormatter.string(from: date)
//            let tomorrowString = LocalizedStringKey("Tomorrow").localizedString(identifier: appLanguage)
//            return "\(tomorrowString) at \(timeString)"
//        } else {
//            let dateYear = calendar.component(.year, from: date)
//            let currentYear = calendar.component(.year, from: now)
//            
//            dateFormatter.timeStyle = .short
//            
//            if dateYear == currentYear {
//                // Example: Tue, May 7, 5:00 PM
//                dateFormatter.dateFormat = "EEE, MMM d, h:mm a"
//            } else {
//                // Example: Tue, 2024 May 7, 5:00 PM
//                dateFormatter.dateFormat = "EEE, yyyy MMM d, h:mm a"
//            }
//            
//            return dateFormatter.string(from: date).split(separator: " ").map { substring in
//                if substring.count > 1, let firstChar = substring.first {
//                    return String(firstChar).uppercased() + substring.dropFirst()
//                } else {
//                    return substring.capitalized
//                }
//            }
//            .joined(separator: " ")
//        }
//    }
//    
//}
//
//struct Service: Identifiable, Equatable, Hashable {
//    
//    var id: String?
//    var name: String?
//    var price: Double?
//    var currency: Currency?
//    
//    static var mock = Service(name: "Soch olish", price: 50_000, currency: .uzs)
//    static var mock2 = Service(name: "Soqol olish", price: 40_000, currency: .uzs)
//    static var mocks: [Service] = [.mock, .mock2]
//    
//}
