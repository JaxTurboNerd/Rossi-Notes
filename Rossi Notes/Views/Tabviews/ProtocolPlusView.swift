//
//  ProtocolPlusView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct ProtocolPlusView: View {
    @StateObject private var viewModel: PlusViewModel
    @State var triggerRefresh: Bool = false
    @State private var showForm = false
    private var appwrite: Appwrite
    
    init(appwrite: Appwrite){
        _viewModel = StateObject(wrappedValue: PlusViewModel(appwrite: appwrite))
        self.appwrite = appwrite
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                MainBackgroundView()
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .controlSize(.large)
                    } else {
                        Group {
                            List(viewModel.documents, id: \.id){document in
                                let name = document.data["name"]?.description ?? ""
                                let id = document.data["$id"]?.description ?? ""
                                CardView(name: name)
                                    .overlay {
                                        NavigationLink(destination: DetailView(appwrite: appwrite, triggerRefresh: $triggerRefresh, collectionId: viewModel.collectionId, documentId: id), label: {EmptyView()})
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
                                    .sheet(isPresented: $showForm, content: {CreateView(appwrite: appwrite, collectionId: viewModel.collectionId, triggerRefresh: $triggerRefresh)})
                                    
                                })
                            }
                            
                        }
                    }
                }
            }
        }
        .onChange(of: triggerRefresh, {
            Task {
                do {
                    try await viewModel.refreshDocuments()
                } catch {
                    print("fetch error: \(error.localizedDescription)")
                }
            }
            triggerRefresh = false
        })
        .refreshable {
            Task {
                do {
                    try await viewModel.refreshDocuments()
                } catch {
                    print("Refresh error \(error.localizedDescription)")
                }
            }
        }
    }
}

//#Preview {
//    ProtocolPlusView()
//}
