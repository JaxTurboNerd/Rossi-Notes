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
        NavigationView {
            List(0..<5, id: \.self){_ in
                CardView()
            }
            .navigationTitle("Protocol")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing,
                            content: {
                    Button("Add Note"){
                        //code
                        
                    }
                })
            }
        }
    }
}

#Preview {
    ProtocolView()
}
