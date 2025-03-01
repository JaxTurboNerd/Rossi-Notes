//
//  ProtocolView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI
import Foundation

struct ProtocolView: View {
    
    //@ObservedObject private var viewModel = ProtocolViewModel()
    @StateObject var viewModel: ProtocolViewModel
    @State var triggerRefresh: Bool = false
    @State private var showForm = false
    
    init(appwrite: Appwrite){
        _viewModel = StateObject(wrappedValue: ProtocolViewModel(appwrite: appwrite))
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
                        Text("Test")
//                        List(viewModel.documents, id: \.id){document in
//                            let name = document.data["name"]?.description ?? ""
//                            let id = document.data["$id"]?.description ?? ""
//                            //let documentDetail = document.description.data(using: .utf8)
//                            CardView(name: name)
//                                .overlay {
//                                    NavigationLink(destination: DetailView(collectionId: viewModel.collectionId, documentId: id, triggerRefresh: $triggerRefresh), label: {EmptyView()})
//                                }
//                        }
//                        .navigationTitle("Protocol")
//                        .navigationBarTitleDisplayMode(.inline)
//                        .toolbar {
//                            ToolbarItem(placement: .topBarTrailing,
//                                        content: {
//                                Button("Add Note"){
//                                    showForm = true
//                                }
//                                //Displays the protocol form to create a new note
//                                .sheet(isPresented: $showForm, content: {CreateView(triggerRefresh: $triggerRefresh, collectionId: viewModel.collectionId)})
//                            })
//                        }
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
