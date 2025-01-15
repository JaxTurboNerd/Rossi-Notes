//
//  ProtocolPlusView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct ProtocolPlusView: View {
    @State private var showForm = false
    @ObservedObject private var viewModel = PlusViewModel()
    
    @State var triggerRefresh: Bool = false
    
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
                                .sheet(isPresented: $showForm, content: {CreateProtocolForm(triggerRefresh: $triggerRefresh, collectionId: viewModel.collectionId)})
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
        .refreshable {
            viewModel.refreshDocuments()
        }
    }
}

//#Preview {
//    ProtocolPlusView()
//}
