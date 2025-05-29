//
//  ReviewLabelView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/21/25.
//

import SwiftUI

struct ReviewLabelView: View {
    let review: Review
    let style: ReviewLabelStyle
    
    var body: some View {
        HStack(spacing: 12) {
            if let image = review.image {
                Image(image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: style.imageFrameSize, height: style.imageFrameSize)
                    .clipShape(
                        RoundedRectangle(cornerRadius: style.imageCornerRadius)
                    )
            }
            VStack(alignment: .leading, spacing: 4) {
                if let name = review.name, !name.isEmpty, let shopName = review.shopName, !shopName.isEmpty {
                    Text(name)
                        .font(.system(size: style.nameFontSize, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(shopName)
                        .font(.system(size: style.subViewsFontSize))
                        .foregroundColor(.secondary)
                }
                HStack(spacing: 4) {
                    if let rate = review.rate {
                        let starSize = style.subViewsFontSize
                        let spacing: CGFloat = 4
                        let totalWidth = (starSize * 5) + (spacing * 4)
                        ZStack(alignment: .leading) {
                            HStack(spacing: spacing) {
                                ForEach(0..<5, id: \.self) { _ in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: style.subViewsFontSize, height: style.subViewsFontSize)
                                        .foregroundStyle(Color.secondary.gradient)
                                }
                            }
                            HStack(spacing: spacing) {
                                ForEach(0..<5) { _ in
                                    Image(systemName: "star.fill")
                                        .resizable()
                                        .frame(width: style.subViewsFontSize, height: style.subViewsFontSize)
                                        .foregroundStyle(Color.accentColor.gradient)
                                }
                            }
                            .mask {
                                Rectangle()
                                    .fill(Color.primary)
                                    .frame(width: totalWidth * CGFloat(rate / 5))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                        }
                        .frame(width: totalWidth)
                        Text(String(format: "%.1f", rate))
                            .font(.system(size: style.ratingFontSize, weight: .semibold))
                            .foregroundStyle(Color.accentColor)
                    }
                    if style.showsDistance == true, let distance = review.distance {
                        Text(distance.formattedDistance)
                            .font(.system(size: 14))
                            .foregroundColor(.secondary)
                            .padding(.leading, 4)
                    }
                }
            }
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .frame(width: 6, height: 12)
                .foregroundColor(.secondary)
        }
        .padding([.vertical, .trailing], 12)
        .padding(.leading, 8)
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
    var ratingFontSize: CGFloat = 14
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
    ReviewLabelView(review: Review(image: "testImage", name: "Jonson", shopName: "Miracle", rate: 4.0), style: .default)
        .padding(.horizontal)
}

#Preview {
    ReviewLabelView(review: Review(image: "testImage", name: "Jonson", shopName: "Shayxontohur, Tashkent", rate: 3.2, distance: nil), style: .onSearchPage)
        .padding(.horizontal)
}
