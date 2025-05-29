//
//  HomeView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine
import CoreLocation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var path = NavigationPath()
    @Published var currentState: CurrentState = .loading
    @Published var allShopsWithDistance: [Shop] = []

    @Published var ordersVM = MyOrdersViewModel()
    @Published var nearbyShopsVM = NearbyShopsViewModel()
    @Published var topRatedShopsVM = TopRatedShopsViewModel()
    @Published var ordinaryShopsVM = OrdinaryShopsViewModel()
    @Published var topReviewsVM = TopReviewsViewModel()

    init() {
        Task {
            await loadHomeViewData()
        }
    }
    /// Barcha HomeView uchun datalarni yuklaydi
    func loadHomeViewData() async {
        self.currentState = .loading
        Task {
            await calculateShopsWithDistance()
            await ordersVM.loadData()
            await nearbyShopsVM.loadData(from: allShopsWithDistance)
            await topRatedShopsVM.loadData(from: allShopsWithDistance)
            await ordinaryShopsVM.loadData(from: allShopsWithDistance)
            await topReviewsVM.loadData()
            self.currentState = .none
        }
    }
    /// Shop ro'yxatiga masofani hisoblab qo'shadi
    func calculateShopsWithDistance() async {
        let mocks = Shop.mocks
        let calculated: [Shop] = mocks.map { shop in
            let distance = LocationService.shared.distance(to: shop)
            return Shop(shop, distance: distance)
        }
        self.allShopsWithDistance = calculated
    }
}

//MARK: - UI
struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            ScrollView(.vertical) {
                LazyVStack(alignment: .leading, spacing: 16) {
                    MyOrdersView(path: $viewModel.path)
                        .environmentObject(viewModel.ordersVM)
                    NearbyShopsView(path: $viewModel.path)
                        .environmentObject(viewModel.nearbyShopsVM)
                    TopRatedShopView(path: $viewModel.path)
                        .environmentObject(viewModel.topRatedShopsVM)
                        .environmentObject(viewModel.nearbyShopsVM)
                    OrdinaryShopsView(path: $viewModel.path)
                        .environmentObject(viewModel.ordinaryShopsVM)
                    TopReviewsView(path: $viewModel.path)
                        .environmentObject(viewModel.topReviewsVM)
                }
                .padding(.top, 24)
                .padding(.bottom, 54)
            }
            .navigationDestination(for: HomeNavigation.self) { destination in
                switch destination {
                case .notification:
                    NotificationView(path: $viewModel.path)
                case .orderDetail(let order):
                    OrderDetailView(order: order)
                case .shopDetails(let shop):
                    ShopCardView(barbershop: shop)
                case .reviewDetails(let review):
                    ReviewLabelView(review: review, style: .default)
                case .notificationDetail(let notification):
                    NotificationLabelView(notification: notification)
                }
            }
            .toolbar(.hidden, for: .tabBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationShadow()
            .toolbar { ToolBarContent() }
            .background(Color.mainBackground)
            .refreshable {
                await viewModel.loadHomeViewData()
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
    case notificationDetail(Notification)
    case orderDetail(Order)
    case shopDetails(Shop)
    case reviewDetails(Review)
}


#Preview {
    HomeView(viewModel: HomeViewModel())
        .environmentObject(TabBarViewModel())
}
