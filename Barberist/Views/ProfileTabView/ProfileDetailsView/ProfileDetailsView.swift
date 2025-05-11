//
//  ProfileDetailsView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/3/25.
//

import SwiftUI
import Combine

final class ProfileDetailsViewModel: ObservableObject {
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""

//    @Published var firstNameWarning: String? = nil
//    @Published var lastNameWarning: String? = nil

    init() {
        loadData()
    }
    func loadData() {  }
    
//    func updateNameField(_ input: String, isFirstName: Bool) {
//        let trimmed = input.trimmingCharacters(in: .whitespaces)
//        guard !trimmed.isEmpty else {
//            if isFirstName {
//                firstName = ""
//                firstNameWarning = nil
//            } else {
//                lastName = ""
//                lastNameWarning = nil
//            }
//            return
//        }
//        if !trimmed.isValidNameCharacters {
//            if isFirstName {
//                firstNameWarning = "Faqat harflar, bo‘sh joy va ' belgisi ruxsat etiladi"
//            } else {
//                lastNameWarning = "Faqat harflar, bo‘sh joy va ' belgisi ruxsat etiladi"
//            }
//            return
//        }
//        let capped = trimmed.prefix(1).capitalized + trimmed.dropFirst().lowercased()
//        let formatted = String(capped.prefix(20))
//        if isFirstName {
//            firstName = formatted
//            firstNameWarning = formatted.isValidName ? nil : "Noto‘g‘ri ism formati"
//        } else {
//            lastName = formatted
//            lastNameWarning = formatted.isValidName ? nil : "Noto‘g‘ri familiya formati"
//        }
//    }
//    
//    func updateFirstName(_ input: String) {
//        // 1. Ortiqcha bo'sh joylarni olib tashlash
//        let trimmed = input.trimmingCharacters(in: .whitespaces)
//        // 2. Agar input bo'sh bo'lsa, hammasini tozalash
//        guard !trimmed.isEmpty else {
//            firstName = ""
//            firstNameWarning = nil
//            return
//        }
//        // 3. Faqat harflar, bo‘sh joylar, apostrof, va tirega ruxsat
//        if !trimmed.isValidNameCharacters {
//            firstNameWarning = "Faqat harflar, bo‘sh joylar va ba’zi belgilar (-, ’)ga ruxsat"
//            return
//        }
//        // 4. Birinchi harfni katta, qolganini kichik harfga o‘girish
//        let lowercased = trimmed.lowercased()
//        let capped = lowercased.prefix(1).capitalized + lowercased.dropFirst()
//        // 5. Maks 20ta belgi bilan cheklash
//        firstName = String(capped.prefix(20))
//        // 6. Yakuniy validatsiya
//        firstNameWarning = firstName.isValidName ? nil : "Noto‘g‘ri ism formati"
//    }

}

//MARK: - UI
struct ProfileDetailsView: View {
    @StateObject var viewModel = ProfileDetailsViewModel()
    @EnvironmentObject var tabBarviewModel: TabBarViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ProfilePictureView()
                    MainTextField(title: "Ismingiz",
                                  placeholder: "Ism",
                                  text: $viewModel.firstName)
                        .focused($focusedField, equals: .firstName)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .lastName }
                        .textOnly($viewModel.firstName)
                    MainTextField(title: "Familiyangiz (ixtiyoriy)", placeholder: "Familiya", text: $viewModel.lastName)
                        .focused($focusedField, equals: .lastName)
                        .submitLabel(.next)
                        .onSubmit { focusedField = .phoneNumber }
                        .textOnly($viewModel.firstName)
                    PhoneNumberView(title: "Telefon raqamingiz", countryCode: "+998",
                                    placeholder: "Telefon raqam", number: $viewModel.phoneNumber)
                        .focused($focusedField, equals: .phoneNumber)
                        .numberPadWithDoneButton(isFocused: focusedField == .phoneNumber)
                        .onChange(of: viewModel.phoneNumber) { _, newValue in
                            viewModel.phoneNumber = newValue.formattedPhoneNumber()
                        }
                    DeleteButton()
                }
                .padding(.horizontal)
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .navigationShadow()
            .background(Color.myBackground)
            .navigationBarBackButtonHidden(true)
            .toolbar { ToolBarContent() }
            .onAppear {
                tabBarviewModel.isTabBarHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    focusedField = .firstName
                }
            }
            .padding(.bottom, -8)
            SaveButton()
                .background(Color.myBackground)
        }
    }
    //MARK: - Subview methods.
    
    @ToolbarContentBuilder
    private func ToolBarContent() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            Button {
                withAnimation { tabBarviewModel.isTabBarHidden = false }
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.headline)
            }
        }
    }
    
    @ViewBuilder
    private func DeleteButton() -> some View {
        Button(role: .destructive) {
            // to delete account action
        } label: {
            Text("Profilni o'chirish")
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.white)
                .cornerRadius(12)
        }
        .padding(.top, 10)
    }
    
    @ViewBuilder
    private func SaveButton() -> some View {
        Button(action: {
            // action
        }, label: {
            Text("Saqlash")
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(viewModel.firstName.isEmpty
                            || viewModel.phoneNumber.isEmpty
                            ? Color.gray.opacity(0.5) : Color.accentColor)
                .cornerRadius(12)
        })
        .padding()
        .disabled(viewModel.firstName.isEmpty || viewModel.phoneNumber.isEmpty)
    }
}

private struct ProfilePictureView: View {
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Image(.test)
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            Button(action: {
                // to open image picker
            }, label: {
                Image(.editPencilIcon)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.contentBackground)
                    .padding(4)
                    .background(Circle().fill(Color.accentColor))
            })
        }
        .padding(.top, 20)
    }
}

private struct PhoneNumberView: View {
    var title: LocalizedStringKey
    var countryCode: String
    var placeholder: LocalizedStringKey
    @Binding var number: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.primary)
            HStack(spacing: 1) {
                Text(countryCode)
                    .padding(17)
                    .frame(minWidth: 64)
                    .frame(height: 48)
                    .background(Color.contentBackground)
                    .cornerRadius(10, corners: [.topLeft, .bottomLeft])
                TextField(placeholder, text: $number)
                    .keyboardType(.numberPad)
                    .padding(.horizontal)
                    .frame(height: 48)
                    .frame(maxWidth: .infinity)
                    .background(Color.contentBackground)
                    .cornerRadius(10, corners: [.topRight, .bottomRight])
            }
        }
    }
}

enum Field: Hashable {
    case firstName, lastName, phoneNumber
}

extension View {
    func numberPadWithDoneButton(isFocused: Bool) -> some View {
        self.toolbar {
            ToolbarItem(placement: .keyboard) {
                if isFocused {
                    Button("Done") {
                        Utils.dismissKeyboard()
                    }
                }
            }
        }
    }
}

extension View {
    func textOnly(_ text: Binding<String>, maxLength: Int = 20) -> some View {
        self.modifier(TextOnlyModifier(text: text, maxLength: maxLength))
    }
}

struct TextOnlyModifier: ViewModifier {
    @Binding var text: String
    var maxLength: Int = 20

    func body(content: Content) -> some View {
        content
            .onChange(of: text) { _, newValue in
                var filtered = newValue
                    .trimmingCharacters(in: .whitespaces)
                    .filter { $0.isLetter }
                if let first = filtered.first {
                    filtered = first.uppercased() + filtered.dropFirst().lowercased()
                }
                if filtered.count > maxLength {
                    filtered = String(filtered.prefix(maxLength))
                }
                if text != filtered {
                    text = filtered
                }
            }
    }
}

#Preview {
    ProfileDetailsView()
        .environmentObject(TabBarViewModel())
}
