//
//  ProtocolPlusView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct ProtocolPlusView: View {
    @StateObject private var viewModel: PlusViewModel
    @EnvironmentObject private var refresh: Refresh
    @State private var showForm = false
    @State var isPlusNote: Bool = true
    let appwrite: Appwrite
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
        _viewModel = StateObject(wrappedValue: PlusViewModel(appwrite: appwrite))
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
                    List(viewModel.documents.sorted {$0.data["name"]?.description ?? "" < $1.data["name"]?.description ?? ""}, id: \.id){ document in
                        let name = document.data["name"]?.description ?? ""
                        let id = document.data["$id"]?.description ?? ""
                        CardView(name: name)
                            .background(NavigationLink(destination: DetailView(appwrite: appwrite, collectionId: viewModel.collectionId, documentId: id, isPlusNote: $isPlusNote), label: {EmptyView()}))
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Protocol +")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing,
                                    content: {
                            Button("Add Note"){
                                showForm = true
                            }
                            //Displays the protocol form to create a new note
                            .sheet(isPresented: $showForm, content: {CreateView(appwrite: appwrite, collectionId: viewModel.collectionId, isPlusNote: $isPlusNote)})
                            
                        })
                    }
                }
            }
        }
//        .onAppear {
//            if refresh.protocolLevelChanged {
//                Task {
//                    do {
//                        try await viewModel.refreshDocuments()
//                    } catch {
//                        print("fetch error: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
        .onChange(of: refresh.triggerRefresh, {
            Task {
                do {
                    try await viewModel.refreshDocuments()
                    print("Protocol PLUS View refresh was triggered")
                } catch {
                    print("fetch error: \(error.localizedDescription)")
                }
            }
            refresh.triggerRefresh = false
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

#Preview {
    let appwrite = Appwrite()
    ProtocolPlusView(appwrite: appwrite)
}
