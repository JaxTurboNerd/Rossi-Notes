//
//  ProtocolPlusView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct ProtocolPlusView: View {
    @State private var showForm = false
    @StateObject private var viewModel = PlusViewModel()
    
    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 500, alignment: .center)
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
                        CardView(name: name)
                            .overlay {
                                NavigationLink(destination: DetailView(name: name), label: {EmptyView()})
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
                            .sheet(isPresented: $showForm, content: {ProtocolForm()})
                        })
                    }
                }
            }
        }
        .onAppear(){
            viewModel.fetchDocuments()
        }
    }
}

#Preview {
    ProtocolPlusView()
}
