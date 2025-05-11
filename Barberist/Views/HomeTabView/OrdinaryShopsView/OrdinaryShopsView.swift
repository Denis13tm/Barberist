//
//  OrdinaryShopsView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/9/25.
//

import SwiftUI

struct OrdinaryShopsView: View {
    @ObservedObject var viewModel = HomeViewModel()
    var body: some View {
        VStack(alignment: .leading) {
            Text("Ordinary")
                .groupedSectionTitleStyle()
            if viewModel.isLoading {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(0..<5, id: \.self) { _ in
                            ShopCardView(barbershop: .mock)
                        }
                    }
                    .padding(.horizontal)
                }
                .redacted(reason: .placeholder)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.barbershops) { barbershop in
                            ShopCardView(barbershop: barbershop)
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
    }
}


#Preview {
    OrdinaryShopsView()
}
