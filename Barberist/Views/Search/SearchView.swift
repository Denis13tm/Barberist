//
//  SearchView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine
import CoreLocation

final class SearchViewModel: ObservableObject {
    @Published var path = NavigationPath()
    @Published var query: String = ""
    @Published var searchedShops: [Review] = []
    @Published var filteredReviews: [Review] = []
    @Published var currentState: CurrentState = .loading

    init() {
        Task {
            await loadSearchedShops()
        }
    }
 
    func loadSearchedShops() async {
        await MainActor.run { currentState = .loading }
        
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        
        let enriched = Review.mocks.map { rev in
            let distance = LocationService.shared.distance(to: rev)
            return Review(rev, distance: distance)
        }
        
        await MainActor.run {
            self.searchedShops = enriched
            self.filteredReviews = []
            self.currentState = .none
        }
    }

    func filterResults() {
        if query.isEmpty {
            filteredReviews = []
        } else {
            filteredReviews = searchedShops.filter {
                ($0.name ?? "").localizedCaseInsensitiveContains(query) ||
                ($0.shopName ?? "").localizedCaseInsensitiveContains(query)
            }
        }
    }
}

//MARK: - UI
struct SearchView: View {
    @StateObject private var viewModel = SearchViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            VStack {
                if viewModel.currentState == .loading {
                    shimmerList
                } else if viewModel.filteredReviews.isEmpty {
                    EmptyStateView(icon: .searchTabIcon, title: "Barbershop topilmadi", subtitle: "Siz qidirgan shoplar mavjud emas")
                } else {
                    shopList
                }
            }
            .navigationDestination(for: SearchViewNavigation.self) { destination in
                switch destination {
                case .map:
                    MapView()
                case .shop(let shop):
                    ReviewLabelView(review: shop, style: .onSearchPage)
                }
            }
            .toolbar {
                ToolBarContent()
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationShadow()
            .background(Color.myBackground)
            .scrollIndicators(.hidden)
            .searchable(text: $viewModel.query)
            .onChange(of: viewModel.query) {
                viewModel.filterResults()
            }
        }
    }
    
    // MARK: - Subviews methods.
    @ToolbarContentBuilder
    private func ToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text("List")
                .font(.system(size: 24, weight: .semibold))
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                viewModel.path.append(SearchViewNavigation.map)
            }, label: {
                Image(.mapIcon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .tint(.primary)
            })
        }
    }
    private var shimmerList: some View {
        List(0..<3, id: \.self) { _ in
            ReviewLabelView(review: .mock, style: .onSearchPage)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
                .makeShimmerEffect()
        }
        .listStyle(.plain)
        
    }
    private var shopList: some View {
        List(viewModel.filteredReviews, id: \.self) { shop in
            ReviewLabelView(review: shop, style: .onSearchPage)
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
                .onTapGesture {
                    viewModel.path.append(SearchViewNavigation.shop(shop))
                }
        }
        .listStyle(.plain)
    }
}

enum SearchViewNavigation: Hashable {
    case map
    case shop(Review)
}

#Preview {
    SearchView()
        .environmentObject(TabBarViewModel())
}
