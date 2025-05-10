//
//  SalonModel.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import Foundation

struct Shop: Identifiable, Hashable {
    var id = UUID()
    var name: String?
    var rating: Double?
    var distance: String?
    var location: String?
    var image: String?
    
    static var mock = Shop(
        name: "Barber Shop",
        rating: 4.5,
        distance: "1.2 km",
        location: "123 Main St, Anytown, USA",
        image: "testImage"
    )
}
