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
            .frame(maxWidth: .infinity, minHeight: 20, maxHeight:70 ,alignment: .center)
            .font(Font.custom("ConcertOne-Regular", size: 28))
            .multilineTextAlignment(.center)
            .foregroundColor(Color("AppBlue"))
            .tracking(1.25)
            .padding([.leading, .trailing], 20)
            .padding([.top, .bottom], 10)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("NameBackground"))
                    .shadow(color: Color.black.opacity(0.4), radius: 2, x: 2, y: 2)
            )
    }
}

#Preview {
    NameView(name: "Lila")
}
