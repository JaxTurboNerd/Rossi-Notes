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
                Text(viewModel.detailsData.name ?? "Name Error")
                    .font(Font.custom("ConcertOne-Regular", size: 28))
                    .tracking(1.5)
                    .padding([.leading, .trailing], 100)
                    .padding([.top, .bottom], 20)
                    .addBorder(Color("AppBlue"), cornerRadius: 10)
                Text(viewModel.detailsData.protocolDate ?? "Date Error")
                Divider()
                    .frame(width: 350, height: 1)
                    .overlay(Color.gray)
                    .padding(.vertical)
                Text(viewModel.detailsData.barrierReactive ?? "Test")
                Text(viewModel.detailsData.dogReactive)
                Text(viewModel.detailsData.doorRoutine ?? "Door Routine Error")
                Text(viewModel.detailsData.resourceGuarder ?? "Resource Error")
                Text(viewModel.detailsData.miscNotes ?? "Notes Error")
                //viewModel.showTextViews()
            }
        }
        .onAppear{
            viewModel.fetchDocument(collectionId: collectionId, documentId: documentId)
        }
    }
}

extension View {
     public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
         let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
         return clipShape(roundedRect)
              .overlay(roundedRect.strokeBorder(content, lineWidth: width))
     }
 }

//#Preview {
//    DetailView()
//}
