//
//  Notification.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/9/25.
//

import Foundation

struct Notification: Identifiable, Hashable {
    var id = UUID()
    var title: String?
    var subtitle: String?
    var message: String?
    var time: String?
    var isRead: Bool?
    var imageName: String?
    
    static var mock = Notification(title: "Fayz salon", subtitle: "Jahongir Oripov", message: "Hurmatli mijoz siz 13:00 Chor 26 Noyabr kun uchun buyurtmangiz mutaxassis...", time: "10:00 PM", isRead: false, imageName: "testImage")
}
