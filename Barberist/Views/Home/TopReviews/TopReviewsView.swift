//
//  TopReviewsView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI
import Combine

final class TopReviewsViewModel: ObservableObject {
    @Published var path = NavigationPath()
    @Published var currentState: CurrentState = .loading
    @Published var reviews: [Review] = []
    
    func loadData() async {
        await MainActor.run {
            self.currentState = .loading
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000)
        await MainActor.run {
            self.reviews = [.mock, .mock2, .mock3]
            self.currentState = .none
        }
    }
}

struct TopReviewsView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var viewModel: TopReviewsViewModel
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Reviews")
                .groupedSectionTitleStyle()
            if viewModel.currentState == .loading {
                ForEach(0..<3, id: \.self) { _ in
                    ReviewLabelView(review: .mock, style: .default)
                        .padding(.horizontal)
                }
                .makeShimmerEffect()
            } else {
                ForEach(viewModel.reviews, id: \.self) { review in
                    ReviewLabelView(review: review, style: .default)
                        .padding(.horizontal)
                        .onTapGesture {
                            path.append(HomeNavigation.reviewDetails(review))
                        }
                }
            }
        }
    }
}

#Preview {
    TopReviewsView(path: .constant(NavigationPath()))
        .environmentObject(TopReviewsViewModel())
}
