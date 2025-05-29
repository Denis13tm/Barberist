//
//  ProfileTabView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    @AppStorage(AppStorageKeys.appLanguage) var language =  Constants.defaultLanguage
    @Published var path = NavigationPath()
    @Published var user = DatabaseManager.instance.getUser()
    
    @Published var isLanguageSheetPresented = false
    @Published var selectedLanguage: AppLanguage = .uz
    @Published var tempSelectedLanguage: AppLanguage = .uz
    @Published var showConfirmChange = false

    init() {
        loadData()
    }
    
    func loadData() {
        if let saved = UserDefaults.standard.string(forKey: "app_language"),
           let lang = AppLanguage(rawValue: saved) {
            selectedLanguage = lang
            tempSelectedLanguage = lang
        }
    }
    
    func didAppear() {
        user = DatabaseManager.instance.getUser()
    }
    
    func openLanguageSheet() {
        tempSelectedLanguage = selectedLanguage
            isLanguageSheetPresented = true
        }
    func closeLanguageSheet() {
        selectedLanguage = tempSelectedLanguage
        isLanguageSheetPresented = false
    }
    func saveLanguageChange() {
        selectedLanguage = tempSelectedLanguage
        UserDefaults.standard.set(selectedLanguage.rawValue, forKey: "app_language")
        isLanguageSheetPresented = false
    }
}

//MARK: - UI
struct SettingsView: View {
    @AppStorage(AppStorageKeys.appLanguage) var language =  Constants.defaultLanguage
    @StateObject var viewModel = SettingsViewModel()

    var body: some View {
        NavigationStack(path: $viewModel.path) {
            List {
                UserProfileView()
                MainSection()
                AdditionalSection()
                SignOutSection()
            }
            .navigationDestination(for: SettingsNavigation.self) { destination in
                switch destination {
                case .profile:
                    ProfileDetailsView()
                case .login:
                    LoginView()
                }
            }
            .listSectionSpacing(8)
            .toolbar(.hidden, for: .tabBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationShadow()
            .toolbar { ToolBarContent() }
            .sheet(isPresented: $viewModel.isLanguageSheetPresented) {
                LanguageSelectionView(viewModel: viewModel).presentationDetents([.height(350)])
            }
            .onAppear { viewModel.didAppear() }
            
        }
    }

    // MARK: - Subviews methods.
    @ToolbarContentBuilder
    private func ToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Text("Settings")
                .font(.system(size: 24, weight: .semibold))
        }
    }
    @ViewBuilder
    private func UserProfileView() -> some View {
            Button(action: {
                if viewModel.user == nil {
                    viewModel.path.append(SettingsNavigation.login)
                } else {
                    viewModel.path.append(SettingsNavigation.profile)
                }
            }, label: {
                HStack(spacing: 8) {
                    ProfileCircle(text: viewModel.user?.initialLetters(), imageUrl: viewModel.user?.imageUrl, size: 72)
                    if let user = viewModel.user {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullName())
                                .font(.system(size: 17, weight: .medium))
                            Text("Customer")
                                .foregroundColor(.secondary)
                                .font(.system(size: 14))
                        }
                    } else {
                        VStack(alignment: .leading, spacing: 6) {
                            Text("Login")
                                .font(.system(size: 17, weight: .medium))
                            Text("After login, you can make reservations")
                                .foregroundColor(.secondary)
                                .font(.system(size: 14))
                        }
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(.secondary.opacity(0.5))
                }
            })
    }
    @ViewBuilder
    private func MainSection() -> some View {
        SettingsCustomSection(title: "Main") {
            Toggle(isOn: .constant(false)) {
                HStack {
                    SettingsIconView(icon: .asset(.bellicon))
                    Text("Notification")
                }
            }
        }
        .foregroundStyle(.primary)
        SettingsCell(title: "Login as Specialist", icon: .asset(.personIcon), action: {
            // Specialist action
        })
        .foregroundStyle(.primary)
    }
    @ViewBuilder
    private func AdditionalSection() -> some View {
        SettingsCustomSection(title: "Additional") {
            SettingsCell(title: "Language", icon: .asset(.globeIcon), type: .navigation, action: {
                viewModel.openLanguageSheet()
            }){
                Text(viewModel.selectedLanguage.title)
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
            SettingsCell(title: "Share", icon: .asset(.circularShareIcon), action: {
                // Share action
            })
            SettingsCell(title: "Privacy Policy", icon: .asset(.checkShieldIcon), action: {
                // // Privacy Policy action
            })
            SettingsCell(title: "Terms of Service", icon: .asset(.shareIcon), action: {
                // Terms of Service action
            })
            SettingsCell(title: "Terms of Use", icon: .asset(.shareIcon), action: {
                // Terms of Use action
            })
        }
        .foregroundStyle(.primary)
    }
    @ViewBuilder
    private func SignOutSection() -> some View {
        SettingsCustomSection {
            SettingsCell(title: "Sign out", icon: .asset(.signOutIcon), action: {
                // Sign out action
            })
            .foregroundStyle(.red)
        }
    }
}



// MARK: - Custom Components
private struct SettingsCustomSection<Content: View>: View {
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

// MARK: - Helpers
enum SettingsNavigation: Hashable {
    case profile
    case login
}

#Preview {
    SettingsView()
        .environmentObject(TabbarViewModel())
}
