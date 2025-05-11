//
//  Utils.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/10/25.
//

import SwiftUI
import UIKit
import CoreLocation

class Utils {
    
    static let shared = Utils()
    
    func requestNotificationAuthorization(completion: @escaping (Bool, Error?) -> ()) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted, error)
            }
        }
    }
    
    static func hapticFeedback(style: UIImpactFeedbackGenerator.FeedbackStyle = .light) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }
    
    static func notificationFeedback(_ feedback: UINotificationFeedbackGenerator.FeedbackType = .error) {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.prepare()
        notificationFeedback.notificationOccurred(feedback)
    }
    
    static func dismissKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    static var getCurrentVendorId: String? {
        var currentVendorId = UserDefaults.standard.string(forKey: "currentVendorId")
        if currentVendorId == nil {
            currentVendorId = UUID().uuidString
            UserDefaults.standard.set(currentVendorId, forKey: "currentVendorId")
        }
        return currentVendorId
    }
    
    static func updateVendorId() {
        UserDefaults.standard.set(UUID().uuidString, forKey: "currentVendorId")
    }
    
    func compressImage(image: UIImage?) -> UIImage? {
        let maxSize = 5000000
        guard var jpgData = image?.jpegData(compressionQuality: 1) else { return nil }
        let currentSize = jpgData.count
        if currentSize > maxSize {
            let image = CIImage(data: jpgData)
            let filter = CIFilter(name: "CILanczosScaleTtansform")
            filter?.setValue(image, forKey: kCIInputImageKey)
            filter?.setValue(0.5, forKey: kCIInputScaleKey)
            if let result = filter?.outputImage {
                let converter = UIImage(ciImage: result)
                if let data = converter.jpegData(compressionQuality: 1) {
                    jpgData = data
                }
            }
        }
        let newSize = jpgData.count
        let  newImage = UIImage(data: jpgData)
        if newSize > maxSize {
            return compressImage(image: newImage)
        }
        return newImage
    }
    
    func getPostUrl(_ id: String?) -> URL? {
        if let id, let url = URL(string: "https://www.instagram.com/posts/\(id)/") {
            return url
        }
        return nil
    }
    
    static func parseQueryString(_ query: String?) -> [String: String] {
        var queryItems: [String: String] = [:]
        let pairs = query?.split(separator: "&")
        for pair in pairs ?? [] {
            let keyValue = pair.split(separator: "=")
            if keyValue.count == 2 {
                let key = String(keyValue[0])
                let value = String(keyValue[1])
                queryItems[key] = value
            }
        }
        return queryItems
    }
        
}
