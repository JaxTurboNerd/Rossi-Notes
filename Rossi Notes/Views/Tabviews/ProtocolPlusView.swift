//
//  ProtocolPlusView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct ProtocolPlusView: View {
    //@StateObject private var viewModel: PlusViewModel
    @StateObject private var viewModel: SharedViewModel
    @State var triggerRefresh: Bool = false
    @State private var showForm = false
    let appwrite: Appwrite
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
        _viewModel = StateObject(wrappedValue: SharedViewModel(appwrite: appwrite))
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                MainBackgroundView()
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .controlSize(.large)
                } else {
                    List(viewModel.plusDocuments, id: \.id){ document in
                        let name = document.data["name"]?.description ?? ""
                        let id = document.data["$id"]?.description ?? ""
                        ZStack {
                            CardView(name: name)
                            NavigationLink(destination: DetailView(appwrite: appwrite, triggerRefresh: $triggerRefresh, collectionId: viewModel.plusCollectionId, documentId: id)){
                                EmptyView()
                            }
                            .opacity(0.0)
                        }
                        .listRowBackground(Color("BackgroundMain"))
                        .listRowSeparator(Visibility.hidden, edges: .all)
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

#Preview {
    let appwrite = Appwrite()
    ProtocolPlusView(appwrite: appwrite)
}
