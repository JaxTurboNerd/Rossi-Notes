//
//  CardView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct CardView: View {
    var name: String = ""
    
    var body: some View {
        Text(name)
            .font(Font.custom("ConcertOne-Regular", size: 24))
            .tracking(1.2)//adds letter spacing
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight:70 ,alignment: .center)
            .background(Color("AppBlue"))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    CardView(name: "Lila")
}
