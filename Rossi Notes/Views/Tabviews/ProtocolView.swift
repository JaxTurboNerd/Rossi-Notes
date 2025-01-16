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
    @State var triggerRefresh: Bool = false
    
    //Need to add navigation bar items on the top of the view
    var body: some View {
        NavigationView {
            ZStack {
                MainBackgroundView()
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
                                    NavigationLink(destination: DetailView(collectionId: viewModel.collectionId, documentId: id, triggerRefresh: $triggerRefresh), label: {EmptyView()})
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
                                .sheet(isPresented: $showForm, content: {CreateView(triggerRefresh: $triggerRefresh, collectionId: viewModel.collectionId)})
                            })
                        }
                    }
                }
                
            }
            
        }
        .onChange(of: triggerRefresh, {
            viewModel.refreshDocuments()
            triggerRefresh = false
        })
        .task {
            
        }
        .refreshable {
            viewModel.refreshDocuments()
        }
    }
}
