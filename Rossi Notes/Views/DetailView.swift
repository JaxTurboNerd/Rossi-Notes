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
                VStack{
                    Text(viewModel.detailsData.name)
                        .font(Font.custom("ConcertOne-Regular", size: 28))
                        .tracking(1.5)
                        .padding([.leading, .trailing], 100)
                        .padding([.top, .bottom], 20)
                        .addBorder(Color("AppBlue"), cornerRadius: 10)
                    Text(viewModel.detailsData.protocolDate)
                    Divider()
                        .frame(width: 350, height: 1)
                        .overlay(Color.gray)
                        .padding(.vertical)
                }
                VStack {
                    viewModel.detailsData.barrierReactive.isEmpty ? AnyView(EmptyView()) : AnyView(Text(viewModel.detailsData.barrierReactive))
                    viewModel.detailsData.dogReactive.isEmpty ? AnyView(EmptyView()) : AnyView(Text(viewModel.detailsData.dogReactive))
                    viewModel.detailsData.strangerReactive.isEmpty ? AnyView(EmptyView()) : AnyView(Text(viewModel.detailsData.strangerReactive))
                    viewModel.detailsData.leashReactive.isEmpty ? AnyView(EmptyView()) : AnyView(Text(viewModel.detailsData.leashReactive))
                    viewModel.detailsData.catReactive.isEmpty ? AnyView(EmptyView()) : AnyView(Text(viewModel.detailsData.catReactive))
                    Divider()
                        .frame(width: 350, height: 1)
                        .overlay(Color.gray)
                        .padding(.vertical)
                }
                VStack {
                    viewModel.detailsData.jumpyMouthy.isEmpty ? AnyView(EmptyView()) : AnyView(Text(viewModel.detailsData.jumpyMouthy))
                    viewModel.detailsData.resourceGuarder.isEmpty ? AnyView(EmptyView()) : AnyView(Text(viewModel.detailsData.resourceGuarder))
                    viewModel.detailsData.doorRoutine.isEmpty ? AnyView(EmptyView()) : AnyView(Text(viewModel.detailsData.doorRoutine)
                    )
                    viewModel.detailsData.placeRoutine.isEmpty ? AnyView(EmptyView()) : AnyView(Text(viewModel.detailsData.placeRoutine))
                    viewModel.detailsData.miscNotes.isEmpty ? AnyView(EmptyView()) : AnyView(Text(viewModel.detailsData.miscNotes)
                    )
                }
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
