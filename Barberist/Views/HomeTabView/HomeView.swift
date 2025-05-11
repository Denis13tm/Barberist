//
//  HomeView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    @Published var path = NavigationPath()
    @Published var isLoading: Bool = false
    
    
    @Published var myOrdersStatus: CurrentState = .loading
    @Published var nearbyStatus: CurrentState = .loading
    @Published var topRatedStatus: CurrentState = .loading
    @Published var ordinaryStatus: CurrentState = .loading
    @Published var topReviewsStatus: CurrentState = .loading
    
    @Published var barbershops: [Shop] = []
    @Published var myOrders: [Order] = []
    @Published var topReviews: [Review] = []

    init() {
        loadHomeViewData()
    }
    
    func loadHomeViewData() {
        self.isLoading = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.loadMockData()
            self.isLoading = false
        }
    }
    
    func loadMockData() {
        self.myOrders = (0..<1).map {
            Order(image: "testImage", name: "Ganzo Feruz \($0)", status: "Active", price: "45 000 UZS", serviceCount: "2 services", date: "Sun, 12 May, 4:45 PM")
        }
        self.barbershops = (0..<5).map {
            Shop(name: "Salon \($0)", rating: 4.5, distance: "1.\($0) km", location: "Shayxontohur, Tashkent", image: "testImage")
        }
        self.topReviews = (0..<5).map {
            Review(image: "testImage", name: "Dave Jonson \($0)", shopName: "Fayz Shop", rateImage: "star_icon", rate: "5")
        }
    }
    
    func showDetails(of order: Order) {
        path.append(HomeNavigation.orderDetail(order))
    }
}
//MARK: - UI
struct HomeView: View {
    @StateObject var viewModel = HomeViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 16) {
                    MyOrdersView(viewModel: viewModel)
                    NearbyShopsView()
                    TopRatedShopView()
                    OrdinaryShopsView()
                    TopReviewsView()
                }
                .padding(.top, 24)
                .padding(.bottom, 54)
            }
            .navigationDestination(for: HomeNavigation.self) { destination in
                switch destination {
                case .orderDetail(let order):
                    OrderDetailView(order: order)
                case .notification:
                    NotificationView()
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationShadow()
            .toolbar { ToolBarContent() }
            .background(Color.mainBackground)
            .refreshable {
                viewModel.loadHomeViewData()
            }
            .scrollIndicators(.hidden)
        }
    }
    
    // MARK: - Subviews methods.
    @ToolbarContentBuilder
    private func ToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text("Barberist")
                .font(.system(size: 24, weight: .semibold))
        }
        ToolbarItem(placement: .topBarTrailing) {
            Button(action: {
                viewModel.path.append(HomeNavigation.notification)
            }, label: {
                Image(.bellicon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(.black)
            })
        }
    }
}

enum HomeNavigation: Hashable {
    case notification
    case orderDetail(Order)
}

#Preview {
    HomeView()
        .environmentObject(TabBarViewModel())
}
