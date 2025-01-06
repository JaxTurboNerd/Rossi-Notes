//
//  NameView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 1/5/25.
//

import SwiftUI

struct NameView: View {
    var name: String?
    var body: some View {
        Text(name ?? "")
            .font(Font.custom("ConcertOne-Regular", size: 28))
            .tracking(1.25)
            .padding([.leading, .trailing], 120)
            .padding([.top, .bottom], 20)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray)
                    .shadow(color: Color.black.opacity(0.4), radius: 2, x: 2, y: 2)
            )
    }
}

#Preview {
    NameView(name: "Artie")
}
