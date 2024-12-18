//
//  ProtocolPlusView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct ProtocolPlusView: View {
    @State private var showForm = false
    
    var body: some View {
        NavigationView {
            List(0..<4, id: \.self){_ in
                CardView()
            }
            .navigationTitle("Protocol +")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing,
                            content: {
                    Button("Add Note"){
                        showForm = true
                    }
                    //Displays the protocol form to create a new note
                    .sheet(isPresented: $showForm, content: {ProtocolForm()})
                })
            }

        }
    }
}

#Preview {
    ProtocolPlusView()
}
