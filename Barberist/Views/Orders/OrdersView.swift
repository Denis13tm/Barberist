//
//  PaymentView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine

final class OrdersViewModel: ObservableObject {
    @Published var orders: [Order] = []
    @Published var currentState: CurrentState = .loading

    init() {
        Task {
            await loadData()
        }
    }
    
    func loadData() async {
        await MainActor.run { currentState = .loading }
    }
}

//MARK: - UI
struct OrdersView: View {
    @StateObject var viewModel = OrdersViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                EmptyStateView(icon: .bagTabIcon, title: "Hali buyurtmalar mavjud emas", subtitle: "Buyurtmalaringiz shu yerda ko'rinadi")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationShadow()
            .background(Color.myBackground)
            .scrollIndicators(.hidden)
            .toolbar { ToolBarContent() }
        }
    }
    
    // MARK: - Subviews methods.
    @ToolbarContentBuilder
    private func ToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text("Orders")
                .font(.system(size: 24, weight: .semibold))
        }
    }
}

#Preview {
    OrdersView()
}
