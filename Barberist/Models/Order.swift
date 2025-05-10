//
//  OrderModel.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/3/25.
//

import Foundation

struct Order: Identifiable, Hashable {
    var id: String?
    var imageName: String?
    var name: String?
    var status: String?
    var price: String?
    var serviceCount: String?
    var date: String?
    
    enum CodingKeys: String, CodingKey {
        case name, status, price, date
        case imageName = "image"
        case serviceCount = "services_count"
    }
    
    static var mock = Order(id: UUID().uuidString, imageName: nil, name: "name")
}
