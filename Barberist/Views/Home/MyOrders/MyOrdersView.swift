//
//  MyOrdersView.swift
//  Barberist
//
//  Created by Otabek Tuychiev.
//

import SwiftUI
import Combine

final class MyOrdersViewModel: ObservableObject {
    @Published var path = NavigationPath()
    @Published var currentState: CurrentState = .loading
    @Published var orders: [Order] = []
    
    func loadData() async {
        await MainActor.run {
            self.currentState = .loading
        }
        try? await Task.sleep(nanoseconds: 1_000_000_000) // fake delay
        await MainActor.run {
            self.orders = [.mock, .mock2, .mock3]
            self.currentState = .none
        }
    }

}

struct MyOrdersView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject var viewModel: MyOrdersViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("My Orders")
                .groupedSectionTitleStyle()
            ScrollView(.horizontal) {
                if viewModel.currentState == .loading {
                    HStack(spacing: 8) {
                        ForEach(0..<2, id: \.self) { _ in
                            OrderCardView(order: .mock)
                        }
                    }
                    .padding(.horizontal)
                    .redacted(reason: .placeholder)
                } else {
                    let orderCount = viewModel.orders.count
                    LazyHStack(spacing: 8) {
                        ForEach(viewModel.orders) { order in
                            OrderCardView(order: order)
                                .frame(width: orderCount == 1 ? .screenWidth - 32 : .screenWidth - 60)
                                .onTapGesture {
                                    path.append(HomeNavigation.orderDetail(order))
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
    MyOrdersView(path: .constant(NavigationPath()))
        .environmentObject(MyOrdersViewModel())
}
