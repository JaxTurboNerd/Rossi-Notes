//
//  ProtocolView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct ProtocolView: View {
    //Need to add navigation bar items on the top of the view
    var body: some View {
        VStack(alignment: .leading) {
            CardView()
            CardView()
            Spacer()
        }
        .padding([.top], 40)
       
    }
}

#Preview {
    ProtocolView()
}
