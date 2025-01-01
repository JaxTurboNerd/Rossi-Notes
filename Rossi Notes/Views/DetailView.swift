//
//  DetailView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/28/24.
//

import SwiftUI
import Appwrite
import JSONCodable
import Foundation

struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    var collectionId = ""
    var documentId = ""
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .controlSize(.large)
            } else if let error = viewModel.errorMessage {
                VStack {
                    Text("Error: \(error)")
                    Button("Retry") {
                        viewModel.fetchDocument(collectionId: collectionId, documentId: documentId)
                    }
                }
            } else {
                Text(viewModel.detailsData.name)
                Text(viewModel.detailsData.protocolDate)
                Text(viewModel.detailsData.miscNotes)
            }
        }
        .onAppear{
            viewModel.fetchDocument(collectionId: collectionId, documentId: documentId)
        }
    }
}

//#Preview {
//    DetailView()
//}
