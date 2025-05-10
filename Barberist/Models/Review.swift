//
//  ReviewModel.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/3/25.
//

import Foundation

struct Review: Identifiable, Hashable {
    var id = UUID()
    var imageName: String
    var name: String
    var shopName: String
    var rateImage: String
    var rate: String
}
