//
//  LoginView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/22/25.
//

import SwiftUI

final class LoginViewModel: ObservableObject {
    @Published var phoneNumber: String = ""
    @Published var firstName: String = ""
    @Published var lastName: String = ""
    @Published var shouldDismiss: Bool = false
    @Published var currentViewType: LoginView.ViewType = .settings
    
    func save() {
        guard isEnabled else { return }
        let user = User(id: UUID().uuidString, firstName: firstName, lastName: lastName, phoneNumber: phoneNumber.fullPhoneNumber.purified)
        DatabaseManager.instance.createUser(user)
        if currentViewType == .settings {
            shouldDismiss = true
        }
    }
    
    var isEnabled: Bool {
        phoneNumber.count >= 12 && firstName.count >= 3
    }
    
}

struct LoginView: View {
    var currentViewType: ViewType = .settings
    @StateObject private var viewModel = LoginViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            Section {
                HStack {
                    Text(Constants.countryCode)
                    Divider()
                    ZStack(alignment: .leading) {
                        Text(viewModel.phoneNumber.dynamicPlaceholder)
                            .foregroundStyle(Color.secondary)
                        TextField("", text: $viewModel.phoneNumber)
                            .textContentType(.telephoneNumber)
                            .keyboardType(.phonePad)
                            .onChange(of: viewModel.phoneNumber) {_ ,newValue in
                                viewModel.phoneNumber = String(newValue.filter({ $0.isNumber }).formattedPhoneNumber.prefix(12))
                            }
                    }
                }
            } header: {
                Text("Telefon raqamingiz")
            } footer: {
                Text("We will sent you a code to verify your phone number.")
            }
            Section {
                TextField("First Name", text: $viewModel.firstName)
                TextField("Last Name", text: $viewModel.lastName)
            } header: {
                Text("Full Name")
            }
            Section {
                Button("Save", action: viewModel.save)
                .frame(maxWidth: .infinity)
                .disabled(viewModel.isEnabled == false)
            }
        }
        .onChange(of: viewModel.shouldDismiss) { _, newValue in
            triggerDismiss(newValue)
        }
        .navigationTitle("Login")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    func triggerDismiss(_ newValue: Bool) {
        if newValue {
            dismiss()
        }
    }
    enum ViewType {
        case settings
    }
}


#Preview {
    LoginView()
}
