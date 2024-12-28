//
//  ProtocolView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI
import Foundation

struct ProtocolView: View {
    
    @State private var showForm = false
    @StateObject private var viewModel = ProtocolViewModel()
    
    
    //Need to add navigation bar items on the top of the view
    var body: some View {
        NavigationView {
            VStack {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 500, alignment: .center)
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("Error: \(error)")
                        Button("Retry") {
                            viewModel.fetchDocuments()
                        }
                    }
                } else {
                    List(viewModel.documents, id: \.id){document in
                        //let name = document.data["name"] ?? "No Name"
                        //Text(document.data["name"]?.description ?? "")
                        let name = document.data["name"]?.description ?? ""
                        CardView(name: name)
                    }
                    .navigationTitle("Protocol")
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
        .onAppear {
            viewModel.fetchDocuments()
        }
    }
}

#Preview {
    ProtocolView()
}
