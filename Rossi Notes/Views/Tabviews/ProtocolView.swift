//
//  ProtocolView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI
import Foundation

struct ProtocolView: View {
    
    @StateObject var viewModel: ProtocolViewModel
    @State var triggerRefresh: Bool = false
    @State private var showForm = false
    private var appwrite: Appwrite
    
    init(appwrite: Appwrite){
        _viewModel = StateObject(wrappedValue: ProtocolViewModel(appwrite: appwrite))
        self.appwrite = appwrite
    }
    
    //Need to add navigation bar items on the top of the view
    var body: some View {
        NavigationView {
            ZStack {
                MainBackgroundView()
                if viewModel.isLoading {
                    Group {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .controlSize(.large)
                    }
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
                                .sheet(isPresented: $showForm, content: {CreateView(appwrite: appwrite, collectionId: viewModel.collectionId, triggerRefresh: $triggerRefresh)})
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
