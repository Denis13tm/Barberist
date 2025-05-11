//
//  SearchView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
    @Published var query: String = ""
    @Published var reviews: [Review] = []
    @Published var filteredReviews: [Review] = []

    init() {
        loadReviews()
    }

    func loadReviews() {
        let mock = (0..<10).map { _ in
            Review(image: "testImage", name: "Fayz salon", shopName: "Shayxontohur, Tashkent", rateImage: "star_icon", rate: "5.0" , distance: "1,5 km")
        }
        self.reviews = mock
        self.filteredReviews = mock
    }

    func filterResults() {
        if query.isEmpty {
            filteredReviews = reviews
        } else {
            filteredReviews = reviews.filter {
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
        NavigationStack {
            List(viewModel.filteredReviews) { review in
                ReviewLabelView(review: review, style: .onSearchPage)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                    .listRowInsets(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationShadow()
            .background(Color.myBackground)
            .scrollIndicators(.hidden)
            .toolbar { ToolBarContent() }
            .searchable(text: $viewModel.query)
            .onChange(of: viewModel.query) {
                viewModel.filterResults()
            }
//            .refreshable {
//                viewModel.loadReviews()
//            }
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
            NavigationLink(destination: MapView()) {
                Image(.mapIcon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .tint(.primary)
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(TabBarViewModel())
}
