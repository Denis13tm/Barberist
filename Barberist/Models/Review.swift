//
//  ReviewModel.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/3/25.
//

import Foundation

struct Review: Identifiable, Hashable {
    var id = UUID()
    var image: String?
    var name: String?
    var shopName: String?
    var rateImage: String?
    var rate: String?
    var distance: String?
    
    static var mock = Review(
        image: "testImage",
        name: "Otabek Tuychiev",
        shopName: "Barberist",
        rateImage: "star_icon",
        rate: "4.5",
    )
}
