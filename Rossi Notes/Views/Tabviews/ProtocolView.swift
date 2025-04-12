//
//  ProtocolView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI
import Foundation

struct ProtocolView: View {
    //@StateObject private var viewModel: ProtocolViewModel
   // @EnvironmentObject private var appwrite: Appwrite
    @StateObject var viewModel = SharedViewModel()
    @State var triggerRefresh: Bool = false
    @State private var showForm = false
        
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
                        List(viewModel.documents, id: \.id){ document in
                            let name = document.data["name"]?.description ?? ""
                            let id = document.data["$id"]?.description ?? ""
                            CardView(name: name)
                                .overlay {
                                    NavigationLink(destination: DetailView(triggerRefresh: $triggerRefresh, collectionId: viewModel.collectionId, documentId: id), label: {EmptyView()})
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
                                .sheet(isPresented: $showForm, content: {CreateView(viewModel: viewModel, collectionId: viewModel.collectionId, triggerRefresh: $triggerRefresh)})
                            })
                        }
                    }
                }
            }
            
        }
//        .onChange(of: triggerRefresh, {
//            Task {
//                do {
//                    try await viewModel.refreshDocuments()
//                } catch {
//                    print("Error refreshing documents: \(error.localizedDescription)")
//                }
//                
//            }
//            triggerRefresh = false
//        })
        .refreshable {
            Task {
                do {
                    try await viewModel.refreshProtocolDocuments()
                } catch {
                    print("refresh error \(error.localizedDescription)")
                }
            }
        }
    }
}
