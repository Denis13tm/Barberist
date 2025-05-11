//
//  ReviewLabelView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI

struct ReviewLabelView: View {
    let review: Review
    let style: ReviewLabelStyle
    
    var body: some View {
        HStack {
            if let image = review.image {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: style.imageFrameSize, height: style.imageFrameSize)
                    .clipShape(
                        RoundedRectangle(cornerRadius: style.imageCornerRadius)
                    )
            }
            VStack(alignment: .leading, spacing: 6) {
                if let name = review.name, !name.isEmpty, let shopName = review.shopName, !shopName.isEmpty {
                    Text(name)
                        .font(.system(size: style.nameFontSize, weight: .semibold))
                        .foregroundColor(.primary)

                    HStack(spacing: 4) {
                        Text(shopName)
                            .font(.system(size: style.subViewsFontSize))
                            .foregroundColor(.secondary)
                    }
                }
                HStack(spacing: 0) {
                    ForEach(0..<5) { _ in
                        Image(review.rateImage ?? "star_icon")
                            .resizable()
                            .frame(width: style.subViewsFontSize, height: style.subViewsFontSize)
                    }
                    if let rate = review.rate {
                        Text(rate)
                            .font(.system(size: style.subViewsFontSize, weight: .semibold))
                            .foregroundStyle(Color.accentColor)
                            .padding(.leading, 4)
                    }
                    if style.showsDistance, let distance = review.distance {
                        Text(distance)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding(.leading, 8)
                    }
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 13))
                .foregroundColor(.secondary)
        }
        .padding(12)
        .background(Color.contentBackground)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
    }
}

struct ReviewLabelStyle {
    var showsDistance: Bool = false
    var showsChevron: Bool = true
    var imageFrameSize: CGFloat = 64
    var imageCornerRadius: CGFloat = 32
    var nameFontSize: CGFloat = 16
    var subViewsFontSize: CGFloat = 12
}

extension ReviewLabelStyle {
    static let `default` = ReviewLabelStyle()
    static let onSearchPage = ReviewLabelStyle(
        showsDistance: true,
        imageFrameSize: 76,
        imageCornerRadius: 4,
        nameFontSize: 20,
        subViewsFontSize: 14
    )
    static let compact = ReviewLabelStyle(
        imageFrameSize: 48,
        imageCornerRadius: 24,
        nameFontSize: 14,
        subViewsFontSize: 10
    )
}

#Preview {
    ReviewLabelView(review: Review(image: "testImage", name: "Jonson", shopName: "Shayxontohur, Tashkent", rateImage: "star_icon", rate: "5.0", ), style: .onSearchPage)
}

#Preview {
    ReviewLabelView(review: Review(image: "testImage", name: "Jonson", shopName: "Miracle", rateImage: "star_icon", rate: "5.0"), style: .default)
}
