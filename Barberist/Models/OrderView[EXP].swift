//
//  OrderView.swift
//  Barberist
//
//  Created by Shohjahon Rakhmatov on 28/04/25.
//

import SwiftUI

//public struct OrderView: View {
//    
//    var order: Order
//    var width: CGFloat = 344
//    var height: CGFloat?
//    
//    init(order: Order) {
//        self.order = order
//    }
//    
//    private init(order: Order, width: CGFloat? = nil, height: CGFloat? = nil) {
//        self.order = order
//        self.width = width ?? 344
//        self.height = height
//    }
//    
//    public var body: some View {
//        HStack(spacing: 12) {
//            if let image = order.image, image.isEmpty == false {
//                CachedImage(imageUrl: image)
//                    .frame(width: width * 0.4, height: (width * 0.4) / 16 * 9)
//                    .clipShape(.rect(cornerRadii: .init(topLeading: 8, bottomLeading: 8)))
//                    .allowsHitTesting(false)
//            }
//            VStack(alignment: .leading, spacing: 0) {
//                if let name = order.name {
//                    Text(name)
//                        .font(.system(size: 18, weight: .semibold))
//                        .foregroundStyle(Color.primary)
//                }
//                if let status = order.status {
//                    Text(status.title)
//                        .font(.system(size: 12))
//                        .foregroundStyle(status.color)
//                }
//                HStack(spacing: 8) {
//                    if let price = order.price, price.isEmpty == false {
//                        Text(price)
//                            .lineLimit(1)
//                            .fontWeight(.semibold)
//                            .foregroundStyle(Color.accentColor)
//                    }
//                    if let services = order.services, services.count > 0 {
//                        Text("\(services.count) services")
//                    }
//                }
//                if let scheduledDate = order.scheduledDate {
//                    Text(scheduledDate)
//                }
//            }
//            .font(.system(size: 12))
//            .foregroundStyle(Color.secondary)
//        }
//        .padding(dynamicInsets)
//        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
//        .frame(width: width, height: height, alignment: .leading)
//        .background(Color.cardBackground)
//        .clipShape(.rect(cornerRadius: 12))
//        .shadow(color: Color.black.opacity(0.04), radius: 8, x: 0, y: 6)
//    }
//    
//    var dynamicInsets: EdgeInsets {
//        if order.image != nil && order.image?.isEmpty == false {
//            return EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 12)
//        } else {
//            return EdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)
//        }
//    }
//    
//    public func frame(width: CGFloat? = nil, height: CGFloat? = nil) -> OrderView {
//        Self(order: order, width: width, height: height)
//    }
//}
//
//#Preview {
//    ScrollView {
//        OrderView(order: .mock)
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .padding(.top, .screenHeight * 0.4)
//    }
//    .background(Color.mainBackground)
//}
