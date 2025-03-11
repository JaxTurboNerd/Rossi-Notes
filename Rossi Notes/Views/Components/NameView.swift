//
//  NameView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 1/5/25.
//

import SwiftUI

struct NameView: View {
    var name: String
    
    var body: some View {
        Text(name)
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight:70 ,alignment: .center)
            .font(Font.custom("ConcertOne-Regular", size: 28))
            .tracking(2)
            .multilineTextAlignment(.center)
            .foregroundColor(.white)
            .background(Color("AppBlue"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    NameView(name: "Lila")
}
