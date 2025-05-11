//
//  NearbyShopsView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI

struct NearbyShopsView: View {
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text("Nearby")
                .groupedSectionTitleStyle()
            if viewModel.isLoading {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { _ in
                            ShopCardView(barbershop: .mock)
                        }
                    }
                    .padding(.horizontal)
                }
                .redacted(reason: .placeholder)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.barbershops) { shop in
                            NavigationLink(destination: Text("Card Details \(String(describing: shop.name))")) {
                                ShopCardView(barbershop: shop)
                            }
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    NearbyShopsView()
}
