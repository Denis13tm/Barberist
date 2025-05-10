//
//  ProfileTabView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    @Published var path = NavigationPath()

    init() {
        loadData()
    }
    
    func loadData() {  }
    
    func signOut() {  }
}

//MARK: - UI
struct SettingsView: View {
    @StateObject var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            List {
                UserProfileHeader()
                MainProfileSection()
                AdditionalProfileSection()
                SignOutSection()
            }
            .listSectionSpacing(8)
            .toolbar(.hidden, for: .tabBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationShadow()
            .toolbar { toolBarContent() }
        }
    }

    // MARK: - Subviews methods.
    @ToolbarContentBuilder
    private func toolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text("Settings")
                .font(.system(size: 24, weight: .semibold))
        }
    }
}

// MARK: - User Profile Header

struct UserProfileHeader: View {
    var body: some View {
        NavigationLink(destination: ProfileDetailsView()) {
            HStack(spacing: 8) {
                Image("testImage")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 72, height: 72)
                    .clipShape(Circle())
                VStack(alignment: .leading, spacing: 4) {
                    Text("Otabek Tuychiev")
                        .font(.system(size: 17, weight: .medium))
                    Text("Customer")
                        .foregroundColor(.secondary)
                        .font(.system(size: 14))
                }
            }
        }
    }
}

// MARK: - Main Profile Section

struct MainProfileSection: View {
    var body: some View {
        ProfileCustomSection(title: "Main") {
            Toggle(isOn: .constant(false)) {
                HStack {
                    ProfileIconView(icon: .asset(.bellicon))
                    Text("Notification")
                }
            }
        }
        NavigationButton(title: "Login as Specialist", icon: .asset(.personIcon)) {
            // Action
        }
    }
}

// MARK: - Additional Profile Section

struct AdditionalProfileSection: View {
    var body: some View {
        ProfileCustomSection(title: "Additional") {
            NavigationButton(title: "Language", icon: .asset(.globeIcon), hasLanguageLabel: true) {
                // Language action
            }
            NavigationButton(title: "Share", icon: .asset(.circularShareIcon)) {
                // Share action
            }
            NavigationButton(title: "Privacy Policy", icon: .asset(.checkShieldIcon)) {
                // Privacy Policy
            }
            NavigationButton(title: "Terms of Service", icon: .asset(.shareIcon)) {
                // Terms of Service
            }
            NavigationButton(title: "Terms of Use", icon: .asset(.shareIcon)) {
                // Terms of Use
            }
        }
    }
}

//MARK: - Sign out Section

struct SignOutSection: View {
    var body: some View {
        ProfileCustomSection {
            NavigationButton(title: "Sign out", icon: .asset(.signOutIcon), role: .destructive) {
                // Sign out action
            }
        }
    }
}

// MARK: - Custom Components

struct ProfileCustomSection<Content: View>: View {
    var title: LocalizedStringKey?
    @ViewBuilder var content: Content

    var body: some View {
        Section {
            content
        } header: {
            if let title {
                Text(title)
                    .font(.system(size: 18, weight: .medium))
                    .textCase(.none)
                    .padding(.horizontal, -16)
            }
        }
    }
}

struct NavigationButton: View {
    var title: LocalizedStringKey
    var icon: ProfileIcon?
    var chevronIcon: String?
    var role: ButtonRole? = nil
    var hasLanguageLabel: Bool = false
    var action: () -> Void

    var body: some View {
        Button(role: role, action: action) {
            if hasLanguageLabel {
                ProfileCellView(title: title, icon: icon, chevronIcon: "chevron.right", languageLabel: "English")
                    .foregroundStyle(role == .destructive ? .red : .primary)
            } else {
                ProfileCellView(title: title, icon: icon, chevronIcon: "chevron.right")
                    .foregroundStyle(role == .destructive ? .red : .primary)
            }
        }
    }
}

struct ProfileCellView: View {
    var title: LocalizedStringKey
    var icon: ProfileIcon?
    var chevronIcon: String?
    var languageLabel: String?

    var body: some View {
        HStack {
            if let icon = icon {
                ProfileIconView(icon: icon)
            }
            Text(title)
            Spacer()
            if let languageLabel = languageLabel {
                Text(languageLabel)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if let chevronIcon = chevronIcon {
                Image(systemName: chevronIcon)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.secondary.opacity(0.5))
            }
        }
    }
}

struct ProfileIconView: View {
    var icon: ProfileIcon

    var body: some View {
        Group {
            switch icon {
            case .system(let name):
                Image(systemName: name)
                    .resizable()
            case .asset(let resource):
                Image(resource)
                    .resizable()
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(width: 24, height: 24)
    }
}

// MARK: - Helpers
enum ProfileIcon {
    case system(String)
    case asset(ImageResource)
}
enum ButtonType {
    case button, navigation
}

#Preview {
    SettingsView()
}
