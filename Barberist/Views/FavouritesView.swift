//
//  FavouritesTabView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine

final class FavouritesViewModel: ObservableObject {
    @Published var welcomeMessage: String = "Welcome to FavouritesTabView!"

    init() {
        loadData()
    }
    func loadData() {  }
}

//MARK: - UI
struct FavouritesView: View {
    @StateObject var viewModel = FavouritesViewModel()
    @State var text = ""
    
    var body: some View {
        Text(viewModel.welcomeMessage)
            .font(.title2)
            .padding()
    }
}

#Preview {
    FavouritesView()
}
