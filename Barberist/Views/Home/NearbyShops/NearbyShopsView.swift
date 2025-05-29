//
//  NearbyShopsView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI
import Combine

@MainActor
final class NearbyShopsViewModel: ObservableObject {
    @Published var currentState: CurrentState = .loading
    @Published var shops: [Shop] = []

    func loadData(from shops: [Shop]) async {
        await MainActor.run { self.currentState = .loading }

        try? await Task.sleep(nanoseconds: 1_000_000_000) // fake delay
        // Faqat yaqin joylashganlar (100 km'dagilarni ko'rsatamiz hozircha!)
        let nearby = shops.filter { ($0.distance ?? 999999) < 100000 }
            .sorted { ($0.distance ?? 999999) < ($1.distance ?? 999999) }

        await MainActor.run {
            self.shops = nearby
            self.currentState = .none
        }
    }
}

struct NearbyShopsView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var viewModel: NearbyShopsViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Nearby")
                .groupedSectionTitleStyle()
            if !LocationService.shared.isPermissionGranted {
                permissionWarning
            } else if viewModel.currentState == .loading {
                skeletonLoader
            } else if viewModel.shops.isEmpty {
                EmptySectionView(iconName: "mappin.slash.circle",
                                 title: "Atrofda yaqin barbershoplar topilmadi",
                                 subtitle: "Joylashuvga yaqinroq joyda urinib ko‘ring.")
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
    private var permissionWarning: some View {
        VStack(spacing: 8) {
            Image(systemName: "location.slash")
                .font(.system(size: 32, weight: .regular))
                .foregroundColor(.secondary)
            Text("Joylashuv ruxsati yo'q")
                .font(.subheadline)
                .foregroundColor(.primary)
            Text("Yaqin atrofdagi salonlarni ko‘rish uchun ilovaga joylashuvga kirish huquqini bering.")
                .font(.footnote)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            Button(action: {
                Utils.openSettings()
            }) {
                Text("Ruxsat berish")
                    .font(.subheadline.weight(.semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background(Color.accentColor)
                    .cornerRadius(8)
            }
            .padding(.horizontal, 50)
        }
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

#Preview {
    NearbyShopsView(path: .constant(NavigationPath()))
        .environmentObject(NearbyShopsViewModel())
}
