//
//  TabbarView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine

final class TabBarViewModel: ObservableObject {
    @Published var isTabBarHidden: Bool = false
}
//MARK: - UI
struct TabBarView: View {
    @EnvironmentObject private var viewModel: TabBarViewModel
    @State private var selection: Tabs = .home
    
    var body: some View {
            TabView(selection: $selection) {
                HomeView()
                    .tag(Tabs.home)
                SearchView()
                    .tag(Tabs.search)
                PaymentView()
                    .tag(Tabs.payments)
                FavouritesView()
                    .tag(Tabs.favorites)
                SettingsView()
                    .tag(Tabs.profile)
            }
            .environmentObject(viewModel)
            .safeAreaInset(edge: .bottom, spacing: 0) {
                    CustomTabBarView()
            }
    }
    // MARK: - Subviews methods.
    @ViewBuilder
    private func CustomTabBarView() -> some View {
        HStack(spacing: 0) {
            ForEach(Tabs.allCases, id: \.self) { tab in
                CustomTabItem(tab)
            }
        }
        .frame(height: 50)
        .background {
            UnevenRoundedRectangle(topLeadingRadius: 0, topTrailingRadius: 0)
                .fill(.thinMaterial)
                .padding(.bottom, -8)
                .ignoresSafeArea()
        }
        .opacity(viewModel.isTabBarHidden ? 0 : 1)
        .animation(.easeInOut(duration: 0.1), value: viewModel.isTabBarHidden)
    }
    @ViewBuilder
    private func CustomTabItem(_ tab: Tabs) -> some View {
        ZStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 25)
                .fill(selection == tab ? Color.accentColor : .clear)
                .frame(width: 46, height: selection == tab ? 2 : 0.0)
                .transition(.scale)
            Image(tab.image)
            .padding(.vertical, 10)
            .foregroundStyle(selection == tab ? .accentColor : Color.secondary)
            .frame(maxWidth: .infinity)
        }.onTapGesture {
            withAnimation(.bouncy(duration: 0.4)) {
                selection = tab
            }
        }
    }}
// MARK: - Helpers.
enum Tabs: String, CaseIterable {
    case home, search, payments, favorites, profile
    var image: ImageResource {
        switch self {
        case .home:
            return .homeTabIcon
        case .search:
            return .searchTabIcon
        case .payments:
            return .bagTabIcon
        case .favorites:
            return .heartTabIcon
        case .profile:
            return .profileTabIcon
        }
    }
}

#Preview {
    TabBarView()
        .environmentObject(TabBarViewModel())
}
