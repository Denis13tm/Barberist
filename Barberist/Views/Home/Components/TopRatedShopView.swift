//
//  TopRatedShopView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI

@MainActor
final class TopRatedShopsViewModel: ObservableObject {
    @Published var currentState: CurrentState = .loading
    @Published var shops: [Shop] = []

    func loadData(from shops: [Shop]) async {
        await MainActor.run { self.currentState = .loading }

        try? await Task.sleep(nanoseconds: 1_000_000_000) // fake delay
        
        let topRated = shops.filter { ($0.rating ?? 0) >= 4.0 }
            .sorted { ($0.rating ?? 0) > ($1.rating ?? 0) }

        await MainActor.run {
            self.shops = topRated
            self.currentState = .none
        }
    }
}

struct TopRatedShopView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var viewModel: TopRatedShopsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Rated")
                .groupedSectionTitleStyle()
            if viewModel.currentState == .loading {
                LazyHStack(spacing: 8) {
                    ForEach(0..<4, id: \.self) { _ in
                        ShopCardView(barbershop: .mock)
                    }
                }
                .padding(.horizontal)
                .makeShimmerEffect()
            } else if viewModel.shops.isEmpty {
                EmptySectionView(iconName: "star.slash",
                                 title: "Yuqori baholanganlar yo‘q",
                                 subtitle: "Yaxshi baholangan barbershoplar hali mavjud emas.")
            } else {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 8) {
                        ForEach(viewModel.shops) { shop in
                            ShopCardView(barbershop: shop)
                                .onTapGesture {
                                    path.append(HomeNavigation.shopDetails(shop))
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
    TopRatedShopView(path: .constant(NavigationPath()))
        .environmentObject(TopRatedShopsViewModel())
        .environmentObject(NearbyShopsViewModel())
}
