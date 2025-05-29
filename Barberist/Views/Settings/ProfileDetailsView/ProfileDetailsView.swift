//
//  ProfileDetailsView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/3/25.
//

import SwiftUI
import Combine

final class ProfileDetailsViewModel: ObservableObject {
    @Published var user: User?
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var phoneNumber: String = ""
    @Published var imageUrl: String?

    init() {
        loadData()
    }
    func loadData() {
        user = DatabaseManager.instance.getUser()
        firstName = user?.firstName ?? ""
        lastName = user?.lastName ?? ""
        phoneNumber = user?.phoneNumber ?? ""
        imageUrl = user?.imageUrl
    }
     func saveChanges() {
         guard var user = user else { return }
         user.firstName = firstName
         user.lastName = lastName
         user.phoneNumber = phoneNumber
         user.imageUrl = imageUrl
         DatabaseManager.instance.updateUser(user)
     }
     func deleteAccount() {
         DatabaseManager.instance.deleteAllUsers()
     }

}

//MARK: - UI
struct ProfileDetailsView: View {
    @StateObject var viewModel = ProfileDetailsViewModel()
    @EnvironmentObject var tabBarviewModel: TabbarViewModel
    @Environment(\.dismiss) var dismiss
    @FocusState private var focusedField: Field?
    
    var body: some View {
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
                    .textOnly($viewModel.lastName)
                PhoneNumberView(title: "Telefon raqamingiz", countryCode: "+998",
                                placeholder: "Telefon raqam", number: $viewModel.phoneNumber)
                    .focused($focusedField, equals: .phoneNumber)
//                        .numberPadWithDoneButton(isFocused: focusedField == .phoneNumber)
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
        }
        .padding(.bottom, -8)
        SaveButton()
            .background(Color.myBackground)
        
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
            viewModel.deleteAccount()
            withAnimation { tabBarviewModel.isTabBarHidden = false }
            dismiss()
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
            viewModel.saveChanges()
            withAnimation { tabBarviewModel.isTabBarHidden = false }
            dismiss()
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
    NavigationStack {
        ProfileDetailsView()
            .environmentObject(TabbarViewModel())
    }
}
