//
//  ProtocolPlusView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct ProtocolPlusView: View {
    @EnvironmentObject private var appwrite: Appwrite
    @StateObject var viewModel = SharedViewModel()
    @State var triggerRefresh: Bool = false
    @State private var showForm = false
    
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
                        List(viewModel.plusDocuments, id: \.id){document in
                            let name = document.data["name"]?.description ?? ""
                            let id = document.data["$id"]?.description ?? ""
                            CardView(name: name)
                                .overlay {
                                    NavigationLink(destination: DetailView(appwrite: appwrite, triggerRefresh: $triggerRefresh, collectionId: viewModel.plusCollectionId, documentId: id), label: {EmptyView()})
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
                                .sheet(isPresented: $showForm, content: {CreateView(collectionId: viewModel.plusCollectionId, triggerRefresh: $triggerRefresh)})
                                
                            })
                        }
                        
                    }
                }
            }
        }
        .onChange(of: triggerRefresh, {
            Task {
                do {
                    try await viewModel.refreshPlusDocuments()
                } catch {
                    print("fetch error: \(error.localizedDescription)")
                }
            }
            triggerRefresh = false
        })
        .refreshable {
            Task {
                do {
                    try await viewModel.refreshPlusDocuments()
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
