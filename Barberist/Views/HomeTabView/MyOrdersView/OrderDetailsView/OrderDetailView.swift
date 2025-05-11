//
//  OrderDetailView.swift
//  Barberist
//
//  Created by Otabek Tuychiev on 5/9/25.
//

import SwiftUI

struct OrderDetailView: View {
    let order: Order
    var body: some View {
        Text(order.name ?? "None")
    }
}

#Preview {
    OrderDetailView(order: Order())
}
