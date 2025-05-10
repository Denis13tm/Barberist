//
//  OrderCardView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI

struct OrderCardView: View {
    let order: Order
    
    var body: some View {
        HStack(spacing: 8) {
            if let imageName = order.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 110)
                    .clipped()
            }
            VStack(alignment: .leading, spacing: 4) {
                if let name = order.name, !name.isEmpty, let status = order.status  {
                    Text(name)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(.primary)
                    Text(status)
                        .font(.caption)
                        .foregroundColor(.accentColor)
                }
                HStack(spacing: 8) {
                    if let price = order.price, let serviceCount = order.serviceCount {
                        Text(price)
                            .font(.caption)
                            .foregroundColor(.accentColor)
                        Text(serviceCount)
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
        .frame(width: 344)
        .background(Color.contentBackground)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        .padding(.vertical, 8)
    }
}

#Preview {
    OrderCardView(order: Order(imageName: "testImage", name: "Ganzo Firoz", status: "Active", price: "45 000 UZS", serviceCount: "2 services", date: "Sun, 12 May, 4:45 PM"))
}
