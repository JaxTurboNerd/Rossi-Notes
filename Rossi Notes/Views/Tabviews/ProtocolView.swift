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
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .controlSize(.large)
                } else if let error = viewModel.errorMessage {
                    VStack {
                        Text("Error: \(error)")
                        Button("Retry") {
                            viewModel.fetchDocuments()
                        }
                    }
                } else {
                    List(viewModel.documents, id: \.id){document in
                        let name = document.data["name"]?.description ?? ""
                        let id = document.data["$id"]?.description ?? ""
                        CardView(name: name)
                            .overlay {
                                NavigationLink(destination: DetailView(collectionId: viewModel.collectionId, documentId: id), label: {EmptyView()})
                            }
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

//#Preview {
//    ProtocolView()
//}
