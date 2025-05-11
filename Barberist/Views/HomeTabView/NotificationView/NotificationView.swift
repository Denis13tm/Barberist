//
//  NotificationView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/2/25.
//

import SwiftUI
import Combine

final class NotificationViewModel: ObservableObject {
    @Published var notifications: [Notification] = []

       init() {
           loadNotifications()
       }

       func loadNotifications() {
           notifications = [
            Notification(title: "Fayz salon", subtitle: "Jahongir Oripov", message: "Hurmatli mijoz siz 13:00 Chor 26 Noyabr kun uchun buyurtmangiz mutaxassis...", time: "10:00 PM", isRead: false, imageName: "testImage"),
            Notification(title: "Fayz saloni", subtitle: "Jahongir Oripov", message: "Hurmatli mijoz sizning 13:00 Chor 26 Noyabr kun uchun buyurtmangiz bekor qilindi.", time: "10:00 PM", isRead: true, imageName: "testImage"),
            Notification(title: "Fayz saloni", subtitle: "Jahongir Oripov", message: "Hurmatli mijoz sizning 13:00 Chor 26 Noyabr kun uchun buyurtmangiz bekor qilindi.", time: "10:00 PM", isRead: true, imageName: "testImage")
           ]
       }
}

//MARK: - UI
struct NotificationView: View {
    @StateObject var viewModel = NotificationViewModel()
    @EnvironmentObject var tabBarviewModel: TabBarViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            ForEach(viewModel.notifications) { notification in
                NotificationLabelView(notification: notification)
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.myBackground)
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
            }
        }
        .navigationTitle("Notifications")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .navigationBar)
        .navigationShadow()
        .toolbar(.hidden, for: .tabBar)
        .background(Color.myBackground)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    withAnimation {
                        tabBarviewModel.isTabBarHidden = false
                    }
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.headline)
                }
            }
        }
        .onAppear {
            tabBarviewModel.isTabBarHidden = true
        }
    }
}

#Preview {
    NotificationView()
        .environmentObject(TabBarViewModel())
}
