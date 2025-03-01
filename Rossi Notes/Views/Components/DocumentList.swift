//
//  DocumentList.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 2/28/25.
//

import SwiftUI
import Appwrite

struct DocumentList: View {
    
    @StateObject private var viewModel: PlusViewModel
    @State var triggerRefresh: Bool = false
    
    init(appwrite: Appwrite){
        _viewModel = StateObject(wrappedValue: PlusViewModel(appwrite: appwrite))
    }
    
    var body: some View {
        List(viewModel.documents, id: \.id){ document in
            let name = document.data["name"]?.description ?? ""
            let id = document.data["$id"]?.description ?? ""
            CardView(name: name)
                .overlay {
                    NavigationLink(destination: DetailView(collectionId: viewModel.collectionId, documentId: id, triggerRefresh: $triggerRefresh), label: {EmptyView()})
                }
        }
//        .navigationTitle("Protocol")
//        .navigationBarTitleDisplayMode(.inline)
//        .toolbar {
//            ToolbarItem(placement: .topBarTrailing,
//                        content: {
//                Button("Add Note"){
//                    showForm = true
//                }
//                //Displays the protocol form to create a new note
//                .sheet(isPresented: $showForm, content: {CreateView(triggerRefresh: $triggerRefresh, collectionId: viewModel.collectionId)})
//            })
//        }
    }
}
