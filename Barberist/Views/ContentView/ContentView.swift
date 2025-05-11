//
//  ContentView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI

struct ContentView: View {
    @State private var isSplashViewShown = true
    
    var body: some View {
        Group {
            if isSplashViewShown {
                SplashView()
                    .onAppear(perform: didSplashViewAppare)
            } else {
                TabBarView()
            }
        }
    }
    //MARK: - Methods
    private func didSplashViewAppare() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: { isSplashViewShown = false })
    }
}

#Preview {
    ContentView()
}
