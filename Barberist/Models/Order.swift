//
//  OrderModel.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/3/25.
//

import Foundation

struct Order: Identifiable, Hashable {
    var id = UUID().uuidString
    var image: String?
    var name: String?
    var status: String?
    var price: String?
    var serviceCount: String?
    var date: String?
    
    enum CodingKeys: String, CodingKey {
        case name, status, price, date
        case image = "image"
        case serviceCount = "services_count"
    }
    
    static var mock = Order(image: "testImage", name: "Name", status: "new", price: "45 000 UZS", serviceCount: "2 services", date: "2025-05-03T12:00:00Z")
    
    struct Service: Identifiable, Hashable, Equatable {
        var id: String?
        var name: String?
        var price : String?
        
        static var mock = Service(id: UUID().uuidString, name: "name", price: "45 000 UZS")
        static var mock2 = Service(id: UUID().uuidString, name: "name2", price: "32 000 UZS")
        static var mocks = Service(id: UUID().uuidString, name: "name3", price: "30 000 UZS")
    }
}
