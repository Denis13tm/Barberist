//
//  ShopCardView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI

struct ShopCardView: View {
    let barbershop: Shop
    var size: CardSize = .regular

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            if let imageName = barbershop.image {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(height: imageHeight)
                    .clipped()
            }
            VStack(alignment: .leading, spacing: 5) {
                if let name = barbershop.name, !name.isEmpty {
                    Text(name)
                        .font(.system(size: nameFontSize, weight: .semibold))
                        .foregroundColor(.primary)
                }
                HStack(spacing: 8) {
                    if let rate = barbershop.rating, let distance = barbershop.distance {
                        Image("star_icon")
                            .resizable()
                            .frame(width: 10, height: 10)
                        Text(String(format: "%.1f", rate))
                        Image("mapSymbol_icon")
                            .resizable()
                            .frame(width: 10, height: 10)
                        Text(distance)
                    }
                }
                .font(.caption)
                .foregroundStyle(.secondary)
                HStack(spacing: 4) {
                    if let location = barbershop.location {
                        Image("pinItem_icon")
                            .resizable()
                            .frame(width: 10, height: 10)
                        Text(location)
                            .lineLimit(1)
                    }
                }
                .font(.caption)
                .foregroundColor(.gray)
            }
            .padding(8)
        }
        .background(Color.contentBackground)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
        .frame(width: cardWidth)
        .padding(.bottom, 6)
    }

    // MARK: - Dynamic values
    private var imageHeight: CGFloat {
        switch size {
        case .compact: return 80
        case .regular: return 94
        case .large: return 120
        }
    }

    private var cardWidth: CGFloat {
        switch size {
        case .compact: return 150
        case .regular: return 178
        case .large: return 220
        }
    }

    private var nameFontSize: CGFloat {
        switch size {
        case .compact: return 14
        case .regular: return 16
        case .large: return 18
        }
    }
}

enum CardSize {
    case compact, regular, large
}

#Preview {
    ShopCardView(barbershop: Shop(name: "Fayz", rating: 4.0, distance: "", location: "", image: "testImage"))
}
