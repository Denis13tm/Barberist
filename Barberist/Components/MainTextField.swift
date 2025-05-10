//
//  MainTextField.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/8/25.
//

import SwiftUI

struct MainTextField: View {
    var title: LocalizedStringKey
    var placeholder: LocalizedStringKey
    @Binding var text: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
            
            TextField(placeholder, text: $text)
                .padding()
                .background(Color.contentBackground)
                .cornerRadius(10)
        }
    }
}
#Preview {
    @Previewable @State var value: String = "ALI"
    MainTextField(title: "Name", placeholder: "name", text: $value)
}
