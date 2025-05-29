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
        HStack(spacing: 12) {
            if let image = order.image, !image.isEmpty {
                CachedImage(imageUrl: image)
                    .frame(width: width * 0.33, height: 110)
                    .clipped()
            }
            VStack(alignment: .leading, spacing: 4) {
                if let name = order.name, !name.isEmpty, let status = order.status {
                    Text(name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(status.title)
                        .font(.caption)
                        .foregroundColor(Color.accentColor)
                }
                HStack(spacing: 8) {
                    if let price = order.price, !price.isEmpty, let services = order.services, services.count > 0 {
                        Text(price)
                            .lineLimit(1)
                            .font(.caption.bold())
                            .foregroundColor(.accentColor)
                        Text("\(services.count) services")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                if let dateString = order.scheduledDate {
                    Text(dateString)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding(.leading, order.image?.isEmpty ?? true ? 12 : 0)
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
            .padding(.top, UIScreen.main.bounds.height * 0.33)
    }
    .background(Color.mainBackground)
}
