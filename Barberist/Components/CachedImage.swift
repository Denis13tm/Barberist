//
//  CachedImage.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/10/25.
//

import SwiftUI
import Kingfisher

struct CachedImage: View {
    let imageUrl: URL?
    let contentMode: SwiftUI.ContentMode
    
    init(imageUrl: String, expiration: StorageExpiration = .days(1), contentMode: SwiftUI.ContentMode = .fill) {
        self.imageUrl = URL(string: imageUrl)
        self.contentMode = contentMode
        Kingfisher.ImageCache.default.memoryStorage.config.countLimit = 100
        Kingfisher.ImageCache.default.memoryStorage.config.totalCostLimit = 50 * 1024 * 1024
        Kingfisher.ImageCache.default.memoryStorage.config.expiration = .expired
        Kingfisher.ImageCache.default.diskStorage.config.expiration = expiration
    }
    
    var body: some View {
        KFImage(imageUrl)
            .fade(duration: 0.25)
            .resizable()
            .aspectRatio(contentMode: contentMode)
    }
}

final class ImagePrefetcher {
    static let instance = ImagePrefetcher()
    var prefetchers: [String: Kingfisher.ImagePrefetcher] = [:]
    
    private init() {}
    
    func startPrefetching(id: String, urls: [String]) {
        prefetchers[id] = Kingfisher.ImagePrefetcher(urls: urls.compactMap { URL(string: $0) })
        prefetchers[id]?.start()
    }
    
    func stopPrefetching(id: String) {
        prefetchers[id]?.stop()
    }
}

#Preview {
    CachedImage(imageUrl: "https://c4.wallpaperflare.com/wallpaper/801/387/806/sea-man-asian-kimono-wallpaper-preview.jpg")
        .frame(width: .screenWidth, height: .screenWidth * 0.67)
        .clipped()
}

