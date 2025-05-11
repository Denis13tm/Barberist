//
//  TopReviewsView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI

struct TopReviewsView: View {
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Top Reviews")
                .groupedSectionTitleStyle()
            if viewModel.isLoading {
                ForEach(0..<5, id: \.self) { _ in
                    ReviewLabelView(review: .mock, style: .default)
                        .padding(.horizontal)
                }
                .redacted(reason: .placeholder)
            } else {
                ForEach(viewModel.topReviews) { review in
                    ReviewLabelView(review: review, style: .default)
                        .padding(.horizontal)
                }
            }
        }
    }
}

#Preview {
    TopReviewsView()
}
