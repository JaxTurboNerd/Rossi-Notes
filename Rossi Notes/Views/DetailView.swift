//
//  DetailView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/28/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    @State private var showUpdateForm = false
    var collectionId = ""
    var documentId = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                NameBackgroundView()
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
                        VStack {
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
                            }
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10).stroke(Color.black, lineWidth: 1)
                                    .shadow(color: Color.black.opacity(0.4), radius: 2, x: 2, y: 2)
                            )
                            .background(Color("BackgroundMain"))
                            Spacer()
                        }
                    }
                }
                .padding()//adds padding to the outer-most view
                .onAppear{
                    viewModel.fetchDocument(collectionId: collectionId, documentId: documentId)
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing,
                        content: {
                Button("Edit Note"){
                    showUpdateForm = true
                }
                //Displays the update form:
                .sheet(isPresented: $showUpdateForm, content: {Text("Update From in work!")})
            })
        }
    }
}

struct NameBackgroundView: View {
    
    var body: some View {
        Color("NameBackground")//custom color with dark mode support
            .ignoresSafeArea(.all)
    }
}
