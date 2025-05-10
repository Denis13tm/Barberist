//
//  SalonModel.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import Foundation

struct Barbershop: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let rating: Double
    let distance: String
    let location: String
    let imageName: String
}
