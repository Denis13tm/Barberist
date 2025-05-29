//
//  OrdinaryShopsView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/9/25.
//

import SwiftUI
import Combine

@MainActor
final class OrdinaryShopsViewModel: ObservableObject {
    @Published var currentState: CurrentState = .loading
    @Published var shops: [Shop] = []
    
    func loadData(from shops: [Shop]) async {
        await MainActor.run { self.currentState = .loading }
        
        try? await Task.sleep(nanoseconds: 1_000_000_000) // fake delay
        
        let ordinary = shops // .filter { ... } => keyin yozaman, after code-review
        
        await MainActor.run {
            self.shops = ordinary
            self.currentState = .none
        }
    }
}

struct OrdinaryShopsView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var viewModel: OrdinaryShopsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ordinary")
                .groupedSectionTitleStyle()
            if viewModel.currentState == .loading {
                skeletonLoader
            } else if viewModel.shops.isEmpty {
                EmptySectionView(iconName: "mappin.slash.circle",
                                 title: "Oddiy barbershoplar yo‘q",
                                 subtitle: "Reytingi past barbershoplar hozircha mavjud emas.")
            } else {
                shopList
            }
        }
    }
    
    private var skeletonLoader: some View {
        LazyHStack(spacing: 8) {
            ForEach(0..<3, id: \.self) { _ in
                ShopCardView(barbershop: .mock)
            }
        }
        .padding(.horizontal)
        .makeShimmerEffect()
    }
    private var shopList: some View {
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


#Preview {
    OrdinaryShopsView(path: .constant(NavigationPath()))
        .environmentObject(MyOrdersViewModel())
}
