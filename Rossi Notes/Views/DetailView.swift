//
//  DetailView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/28/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    var collectionId = ""
    var documentId = ""
    
    var body: some View {
        ZStack {
            BackgroundView()
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
                    VStack{
                        //Name:
                        NameView(name: viewModel.detailsData.name)
                        //Date:
                        Text("Protocol Date: \(viewModel.detailsData.protocolDate)")
                            .font(.system(size: 20))
                            .fontWeight(.bold)
                            .padding(.vertical)
                        //Details:
                        DetailGroupView(viewModel: viewModel)
                        Spacer()
                    }
                    .padding(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1)
                            .shadow(color: Color.black.opacity(0.4), radius: 2, x: 2, y: 2)
                    )
                }
            }
            .onAppear{
                viewModel.fetchDocument(collectionId: collectionId, documentId: documentId)
            }
            .padding(10)//adds padding to the outer-most view
        }
    }
}
