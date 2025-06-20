//
//  ProtocolView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI
import Foundation

struct ProtocolView: View {
    @StateObject private var viewModel: ProtocolViewModel
    let appwrite: Appwrite
    @EnvironmentObject private var refresh: Refresh
    @Environment(\.dismiss) private var dismiss
    @State var isPlusNote: Bool = false
    @State private var showForm = false
    @State private var showAlert = false
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
        _viewModel = StateObject(wrappedValue: ProtocolViewModel(appwrite: appwrite))
    }
    
    //Need to add navigation bar items on the top of the view
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
                    //used to hide the arrow on the right side from the List of items
                    .scrollContentBackground(.hidden)
                    .navigationTitle("Protocol")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing,
                                    content: {
                            Button("Add Note"){
                                showForm = true
                            }
                            .sheet(isPresented: $showForm, content: {CreateView(appwrite: appwrite, collectionId: viewModel.collectionId, isPlusNote: $isPlusNote)})
                        })
                    }
                    .alert(isPresented: $showAlert){
                        Alert(title: Text("Error"), message: Text("An error occurred fetching data. Please try again later."), dismissButton: .default(Text("OK")))
                    }
                }
            }
        }
        .onChange(of: refresh.triggerRefresh, {
            Task {
                do {
                    try await viewModel.refreshDocuments()
                    print("Protocol View refresh was triggered")
                } catch {
                    print("Error refreshing documents: \(error.localizedDescription)")
                    showAlert = true
                }
            }
            refresh.triggerRefresh = false
        })
        .refreshable {
            Task {
                do {
                    try await viewModel.refreshDocuments()
                } catch {
                    print("refresh error \(error.localizedDescription)")
                    showAlert = true
                }
            }
        }
    }
}

#Preview {
    @Previewable var previewAppwrite = Appwrite()
    ProtocolView(appwrite: previewAppwrite)
}
