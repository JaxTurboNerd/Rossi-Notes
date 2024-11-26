//
//  CardView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct CardView: View {
    @State var name = "Artie"
    
    var body: some View {
        Text("\(name)")
            .font(Font.custom("ConcertOne-Regular", size: 24))
            .tracking(2)//adds letter spacing

            //.frame(minWidth: 300, idealWidth: 350, idealHeight: 70, maxHeight: 75 , alignment: .center)
            .frame(maxWidth: .infinity, minHeight: 60, maxHeight:70 ,alignment: .center)
            .background(Color("AppBlue"))
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding([.horizontal, .bottom])
    }
}

#Preview {
    CardView()
}
