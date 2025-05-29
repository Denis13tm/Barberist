//
//  NotificationLabelView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/9/25.
//

import SwiftUI

struct NotificationLabelView: View {
    let notification: Notification

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack {
                Spacer()
                if let isRead = notification.isRead {
                    if !isRead {
                        Circle()
                            .fill(Color.accentColor)
                            .frame(width: 10, height: 10)
                    } else {
                        Circle()
                            .fill(Color.secondary.opacity(0.3))
                            .frame(width: 10, height: 10)
                    }
                }
                Spacer()
            }
            Divider()
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    if let image = notification.imageName {
                        Image(image)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 32, height: 32)
                            .clipShape(Circle())
                    }
                    VStack {
                        if let title = notification.title, !title.isEmpty, let subtitle = notification.subtitle, !subtitle.isEmpty {
                            Text(title)
                                .font(.system(size: 16, weight: .semibold))
                            Text(subtitle)
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }
                    Spacer()
                    if let time = notification.time, !time.isEmpty {
                        Text(time)
                            .font(.caption)
                            .foregroundColor(.gray)
                    }
                }
                if let message = notification.message, !message.isEmpty {
                    Text(message) // yana date uchun Inner Text View qo'shaman "date" uchun, codereview'dan keyin
                        .font(.system(size: 14))
                        .lineLimit(2)
                }
            }
        }
        .padding()
        .frame(height: 112)
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
    }
}

#Preview {
    VStack {
        Spacer()
        NotificationLabelView(notification: Notification(title: "Fayz salon", subtitle: "Jahongir Oripov", message: "Hurmatli mijoz siz 13:00 Chor 26 Noyabr kun uchun buyurtmangiz mutaxassis...", time: "10:00 PM", isRead: false, imageName: "testImage"))
            .padding(.horizontal)
        Spacer()
    }
    .background(Color.myBackground)
        
}
