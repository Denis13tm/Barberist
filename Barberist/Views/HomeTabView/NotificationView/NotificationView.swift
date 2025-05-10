//
//  NotificationView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine

final class NotificationViewModel: ObservableObject {
    @Published var welcomeMessage: String = "Welcome to NotificationView!"

    init() {
        // Bu yerda kelajakda API chaqirish yoki state tayyorlash bo'ladi
    }
}

//MARK: - UI
struct NotificationView: View {
    @StateObject var viewModel = NotificationViewModel() // MVVM orqali ulanyapti
    @EnvironmentObject var tabBarviewModel: TabBarViewModel
    
    var body: some View {
        VStack {
            Text(viewModel.welcomeMessage)
                .font(.title2)
                .padding()
        }
        .onAppear {
            tabBarviewModel.isTabBarHidden = true
        }
        .onDisappear {
            tabBarviewModel.isTabBarHidden = false
        }
    }
}

#Preview {
    var tabBarviewModel: TabBarViewModel
    NotificationView()
}
