//
//  MainButton.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI

struct MainButton: View {
    var title: LocalizedStringKey
    var isDisabled: Bool
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(isDisabled ? Color.gray.opacity(0.5) : Color.accentColor)
                .cornerRadius(8)
        }
        .padding(.horizontal, 16)
        .disabled(isDisabled)
    }
}

#Preview {
    MainButton(title: "Save", isDisabled: true, action: {})
}
