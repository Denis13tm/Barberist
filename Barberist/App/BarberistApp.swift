//
//  BarberistApp.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI

@main
struct BarberistApp: App {
    @StateObject private var tabBarVM = TabBarViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(tabBarVM)
        }
    }
}
