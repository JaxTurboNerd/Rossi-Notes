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
                    NameView(name: viewModel.detailsData.name)
                    Text("Protocol Date: \(viewModel.detailsData.protocolDate)")
                        .fontWeight(.bold)
                        .padding(.vertical)
                    DetailGroupView(viewModel: viewModel)
                    Spacer()//possibly add minLength?
                }
                .padding(10)
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1))
            }
        }
        .onAppear{
            viewModel.fetchDocument(collectionId: collectionId, documentId: documentId)
        }
        .padding(10)//adds padding to the outer-most view
    }
}

//extension View {
//    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
//        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
//        return clipShape(roundedRect)
//            .overlay(roundedRect.strokeBorder(content, lineWidth: width))
//    }
//}

//#Preview {
//    DetailView()
//}
