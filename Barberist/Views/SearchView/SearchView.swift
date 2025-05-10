//
//  SearchView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
    @Published var welcomeMessage: String = "Welcome to SearchTabView!"

    init() {
        // Bu yerda kelajakda API chaqirish yoki state tayyorlash bo'ladi
        loadData()
    }
    
    func loadData() {  }
}

//MARK: - UI
struct SearchView: View {
    @StateObject var viewModel = SearchViewModel()
    
    var body: some View {
        Text(viewModel.welcomeMessage)
            .font(.title2)
            .padding()
    }
}

#Preview {
    SearchView()
}
