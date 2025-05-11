//
//  OrderCardView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI

struct OrderCardView: View {
    var order: Order
    var width: CGFloat = 344
    var height: CGFloat?

    init(order: Order) {
        self.order = order
    }

    private init(order: Order, width: CGFloat? = nil, height: CGFloat? = nil) {
        self.order = order
        self.width = width ?? 344
        self.height = height
    }

    var body: some View {
        HStack(spacing: 8) {
            if let imageName = order.image {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width * 0.33)
                    .frame(height: 110)
                    .clipped()
            }
            VStack(alignment: .leading, spacing: 4) {
                if let name = order.name, !name.isEmpty, let status = order.status {
                    Text(name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(status)
                        .font(.caption)
                        .foregroundColor(Color.accentColor)
                }
                HStack(spacing: 8) {
                    if let price = order.price, let serviceCount = order.serviceCount {
                        Text(price)
                            .font(.caption)
                            .foregroundColor(.accentColor)
                        Text("\(serviceCount) services")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                if let date = order.date, !date.isEmpty {
                    Text(date)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            Spacer()
        }
        .frame(height: 110)
        .frame(width: width)
        .background(Color.contentBackground)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.vertical, 8)
    }
    
    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> OrderCardView {
        Self(order: order, width: width, height: height)
    }
}

#Preview {
    ScrollView {
        OrderCardView(order: .mock)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.top, UIScreen.main.bounds.height * 0.4)
    }
    .background(Color.mainBackground)
}
