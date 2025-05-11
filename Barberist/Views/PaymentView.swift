//
//  PaymentView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine

final class PaymentViewModel: ObservableObject {
    @Published var welcomeMessage: String = "Welcome to PaymentTabView!"

    init() {
        loadData()
    }
    
    func loadData() {  }
}

//MARK: - UI
struct PaymentView: View {
    @StateObject var viewModel = PaymentViewModel()
    
    var body: some View {
        Text(viewModel.welcomeMessage)
            .font(.title2)
            .padding()
    }
}

#Preview {
    PaymentView()
}
