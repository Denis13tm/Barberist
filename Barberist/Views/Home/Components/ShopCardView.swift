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
            shopImage
            shopInfo
        }
        .frame(height: 176)
        .frame(width: cardWidth)
        .background(Color.contentBackground)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.2), radius: 2, x: 0, y: 2)
        .padding(.bottom, 8)
    }

    // MARK: - Subviews
    @ViewBuilder
    private var shopImage: some View {
        if let imageName = barbershop.image {
            Image(imageName)
                .resizable()
                .scaledToFill()
                .frame(height: imageHeight)
                .clipShape(RoundedCorner(radius: 8, corners: [.topLeft, .topRight]))
        } else {
            Color.gray.opacity(0.3) // image yo'q bo'lsa, placeholder qildim
                .frame(height: imageHeight)
        }
    }
    @ViewBuilder
    private var shopInfo: some View {
        VStack(alignment: .leading, spacing: 6) {
            shopName
            ratingAndDistance
            addressRow
        }
        .padding(8)
    }
    private var shopName: some View {
        Group {
            if let name = barbershop.name, !name.isEmpty {
                Text(name)
                    .font(.system(size: nameFontSize, weight: .semibold))
                    .foregroundColor(.primary)
            }
        }
    }
    private var ratingAndDistance: some View {
        HStack(spacing: 8) {
            if let rate = barbershop.rating {
                Image("star_icon")
                    .resizable()
                    .frame(width: 10, height: 10)
                Text(String(format: "%.1f", rate))
                    .font(.caption)
                    .foregroundStyle(.accent)
            }
            if let distance = barbershop.distance {
                Image("distance_icon")
                    .resizable()
                    .frame(width: 10, height: 10)
                Text(distance.formattedDistance)
                    .font(.caption)
            }
        }
        .font(.caption)
        .foregroundStyle(.primary)
    }
    private var addressRow: some View {
        Group {
            if let address = barbershop.address {
                HStack(spacing: 4) {
                    Image("pinItem_icon")
                        .resizable()
                        .frame(width: 10, height: 10)
                    Text(address)
                        .lineLimit(1)
                }
            } else {
                HStack(spacing: 4) {
                    Color.clear.frame(width: 10, height: 10)
                    Text("").hidden()
                }
            }
        }
        .font(.caption)
        .foregroundColor(.primary)
    }

    // MARK: - Dynamic dimensions
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
    ShopCardView(barbershop: Shop(id: UUID().uuidString, name: "Fayz", image: "testImage", rating: 4.0, address: nil, distance: nil))
}
