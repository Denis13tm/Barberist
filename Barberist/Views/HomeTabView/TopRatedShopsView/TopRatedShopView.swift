//
//  TopRatedShopView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI

struct TopRatedShopView: View {
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Rated")
                .groupedSectionTitleStyle()
            if viewModel.isLoading {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { _ in
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
                            ShopCardView(barbershop: shop)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}
#Preview {
    TopRatedShopView()
}
