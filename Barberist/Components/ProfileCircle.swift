//
//  ProfileCircle.swift
//  Barberist
//
//  Created by Shohjahon Rakhmatov on 18/05/25.
//


import SwiftUI

struct ProfileCircle: View {
    
    var text: String?
    var imageUrl: String?
    var size: CGFloat = 96
    var cornerRadius: CGFloat?
    
    var body: some View {
        ZStack {
            if let imageUrl {
                CachedImage(imageUrl: imageUrl)
            } else if let text {
                Circle()
                    .fill(Color.accentColor.gradient)
                Text(text.uppercased())
                    .foregroundStyle(Color.white)
                    .font(.system(size: size / 2.5, weight: .bold))
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: size, height: size)
                    .foregroundStyle(Color.white, Color.secondary)
            }
        }
        .frame(width: size, height: size)
        .clipShape(.rect(cornerRadius: (cornerRadius == nil ? size / 2 : cornerRadius ?? 0)))
    }
}

#Preview {
    Group {
        ProfileCircle(text: "sR")
        ProfileCircle(text: nil)
    }
}
