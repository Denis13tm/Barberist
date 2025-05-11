//
//  Extensions.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = 12.0
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

extension View {
    func navigationShadow() -> some View {
        modifier(NavigationShadowModifier())
    }
}

struct NavigationShadowModifier: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content.overlay(
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.5)
                .frame(height: 44)
                .shadow(color: colorScheme == .light ? Color.black.opacity(0.2) : Color.white.opacity(0.2), radius: 3, x: 0, y: 3)
                .offset(y: -44),
            alignment: .top
        )
    }
}

extension CGFloat {
    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
}

extension View {
    func groupedSectionTitleStyle() -> some View {
        self
            .font(.system(size: 18, weight: .semibold))
            .foregroundStyle(Color.primary)
            .padding(.horizontal)
    }
}

enum CurrentState {
    case loading
    case none
    case error(Error)
}

enum Device {
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
}

extension String {
    func formattedPhoneNumber(maxDigits: Int = 9) -> String {
        let digits = self.filter { $0.isWholeNumber }
        let limited = String(digits.prefix(maxDigits))
        var formatted = ""
        var index = limited.startIndex
        if limited.count > 0 {
            let end = limited.index(index, offsetBy: min(2, limited.count))
            formatted += String(limited[index..<end])
            index = end
        }
        if index < limited.endIndex {
            let end = limited.index(index, offsetBy: min(3, limited.distance(from: index, to: limited.endIndex)))
            formatted += " " + limited[index..<end]
            index = end
        }
        if index < limited.endIndex {
            let end = limited.index(index, offsetBy: min(2, limited.distance(from: index, to: limited.endIndex)))
            formatted += " " + limited[index..<end]
            index = end
        }
        if index < limited.endIndex {
            let end = limited.index(index, offsetBy: min(2, limited.distance(from: index, to: limited.endIndex)))
            formatted += " " + limited[index..<end]
        }
        return formatted
    }
}
