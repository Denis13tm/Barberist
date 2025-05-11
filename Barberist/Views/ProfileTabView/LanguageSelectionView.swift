//
//  LanguageSelectionView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI

struct LanguageSelectionView: View {
    @ObservedObject var viewModel: SettingsViewModel

    var body: some View {
        VStack(spacing: 20) {
            HeaderView(viewModel: viewModel)
            LanguagesSection(viewModel: viewModel)
            Spacer()
            MainButton(
                title: "Saqlash",
                isDisabled: viewModel.tempSelectedLanguage == viewModel.selectedLanguage
            ) {
                viewModel.showConfirmChange = true
            }
        }
        .padding(.vertical)
        .background(Color(.systemBackground))
        .presentationDetents([.medium])
        .confirmationDialog("Tilni o‘zgartirmoqchimisiz?", isPresented: $viewModel.showConfirmChange, titleVisibility: .visible) {
            Button("Ha", role: .none) {
                viewModel.saveLanguageChange()
            }
            Button("Yo‘q", role: .cancel) { }
        }
    }
}
//MARK: - SubViews
private struct HeaderView: View {
    @ObservedObject var viewModel: SettingsViewModel
    var body: some View {
        HStack {
            Text("Ilova tili").font(.system(size: 24))
            Spacer()
            Button {
                viewModel.isLanguageSheetPresented = false
            } label: {
                Image(systemName: "xmark")
                    .font(.title3)
                    .tint(.primary)
            }
        }
        .padding()
    }
}

struct LanguagesSection: View {
    @ObservedObject var viewModel: SettingsViewModel
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ForEach(AppLanguage.allCases) { lang in
                HStack {
                    Image(lang.flag)
                    Text(lang.title)
                    Spacer()
                    if viewModel.tempSelectedLanguage == lang {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.accentColor)
                    }
                }
                .padding(.vertical, 8)
                .contentShape(Rectangle())
                .onTapGesture {
                    viewModel.tempSelectedLanguage = lang
                }
            }
        }
        .padding(.horizontal)
    }
}

enum AppLanguage: String, CaseIterable, Identifiable {
    var id: String { rawValue }
    case uz, en, ru
    var title: LocalizedStringKey {
        switch self {
        case .uz: return "O‘zbekcha"
        case .en: return "English"
        case .ru: return "Русский"
        }
    }
    var flag: ImageResource {
        switch self {
        case .uz: return .lanUz
        case .en: return .lanEng
        case .ru: return .lanRu
        }
    }
}

#Preview {
    let vm = SettingsViewModel()
    LanguageSelectionView(viewModel: vm)
}
