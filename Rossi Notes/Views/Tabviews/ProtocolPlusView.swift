//
//  ProtocolPlusView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct ProtocolPlusView: View {
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                CardView()
                CardView()
                Spacer()
            }
            .padding([.top], 40)
            .navigationTitle("Protocol +")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing,
                            content: {
                    Button("Add Note"){
                        //code
                        print("note added")
                    }
                })
            }

        }
    }
}

#Preview {
    ProtocolPlusView()
}
