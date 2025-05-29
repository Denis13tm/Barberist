//
//  FavouritesTabView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI

final class FavouritesViewModel: ObservableObject {
    @Published var favourites: [Review] = []
    @Published var currentState: CurrentState = .loading

    init() {
        Task {
            await loadData()
        }
    }

    func loadData() async {
        await MainActor.run { currentState = .loading }

        try? await Task.sleep(nanoseconds: 1_000_000_000)
        let mocks = Review.mocks

        await MainActor.run {
            self.favourites = mocks
            self.currentState = .none
        }
    }
}

//MARK: - UI
struct FavouritesView: View {
    @StateObject var viewModel = FavouritesViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.currentState == .loading {
                    List {
                        ForEach(0..<3, id: \.self) { _ in
                            ReviewLabelView(review: .mock, style: .onSearchPage)
                                .makeShimmerEffect()
                                .listRowSeparator(.hidden)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
                        }
                    }
                    .listStyle(.plain)
                } else {
                    if viewModel.favourites.isEmpty {
                        EmptyStateView(icon: .heartIcon, title: "Siz xali sevimlar tanlamadingiz", subtitle: "Sevimlilar tanlanganda bu yerda ko’rinadi")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        List{
                            ForEach(viewModel.favourites, id: \.self) { review in
                                ReviewLabelView(review: review, style: .onSearchPage)
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 0, trailing: 16))
                            }
                        }
                        .listStyle(.plain)
                    }
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationShadow()
            .background(Color.myBackground)
            .scrollIndicators(.hidden)
            .toolbar { ToolBarContent() }
            .refreshable {
                await viewModel.loadData()
            }
        }
    }
    // MARK: - Subviews methods.
    @ToolbarContentBuilder
    private func ToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text("Favourites")
                .font(.system(size: 24, weight: .semibold))
        }
    }
}

#Preview {
    FavouritesView()
}
