//
//  MyOrdersView.swift
//  Barberist
//
//  Created by Otabek Tuychiev.
//

import SwiftUI

final class MyOrdersViewModel: ObservableObject {
    @Published var currentState: CurrentState = .loading
    
}
// MARK: - UI
struct MyOrdersView: View {
    @ObservedObject var viewModel = HomeViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("My Orders")
                .groupedSectionTitleStyle()
            ScrollView(.horizontal) {
                if viewModel.isLoading {
                    HStack(spacing: 8) {
                        ForEach(0..<4, id: \.self) { _ in
                            OrderCardView(order: .mock)
                        }
                    }
                    .padding(.horizontal)
                    .redacted(reason: .placeholder)
                } else {
                    let orderCount = viewModel.myOrders.count
                        HStack(spacing: 8) {
                            ForEach(viewModel.myOrders) { order in
                                OrderCardView(order: order)
                                    .frame(width: orderCount == 1 ? Device.screenWidth - 32 : Device.screenWidth * 0.75)
                                    .onTapGesture {
                                        viewModel.showDetails(of: order)
                                    }
                            }
                        }
                        .padding(.horizontal)
                }
            }
            
        }
    }
}
