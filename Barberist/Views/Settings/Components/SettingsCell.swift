//
//  SettingsCell.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/23/25.
//

import SwiftUI

struct SettingsCell<Content: View>: View {
    let title: LocalizedStringKey
    let icon: SettingsIcon?
    var action: (() -> Void)?
    let content: Content
    let type: AccessoryType
    
    init(
        title: LocalizedStringKey,
        icon: SettingsIcon? = nil,
        type: AccessoryType = .none,
        action: (() -> Void)? = nil,
        @ViewBuilder content: () -> Content = { EmptyView() }
    ) {
        self.title = title
        self.icon = icon
        self.type = type
        self.action = action
        self.content = content()
    }
    
    var body: some View {
        if let action = action {
            Button(action: action) {
                HStack {
                    if let icon = icon {
                        SettingsIconView(icon: icon)
                    }
                    Text(title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    content
                    if type == .navigation {
                        Image(systemName: "chevron.right")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.secondary.opacity(0.7))
                    }
                }
            }
        }
    }
}

enum SettingsIcon {
    case system(String)
    case asset(ImageResource)
}
enum AccessoryType {
    case none, navigation, toggle
}

struct SettingsIconView: View {
    let icon: SettingsIcon
    var body: some View {
        Group {
            switch icon {
            case .system(let name):
                Image(systemName: name)
                    .resizable()
            case .asset(let resource):
                Image(resource)
                    .resizable()
            }
        }
        .aspectRatio(contentMode: .fit)
        .frame(width: 24, height: 24)
    }
}
