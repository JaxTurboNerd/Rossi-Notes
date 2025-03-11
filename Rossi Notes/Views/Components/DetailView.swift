//
//  DetailView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/28/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject private var viewModel: DetailViewModel
    @StateObject private var updateViewModel: UpdateViewModel
    @EnvironmentObject private var detailsModel: DetailsModel
    private var appwrite: Appwrite
    @State private var showUpdateForm = false
    
    var collectionId: String
    var documentId: String
    //Do not move the two lines below up near the other @State vars (causes odd errors):
    @Binding var triggerRefresh: Bool
    @State private var noteDeleted = false
    @State var noteUpdated = false
    
    //Used to dismiss the form:
    @Environment(\.dismiss) private var dismiss
    
    init(appwrite: Appwrite, triggerRefresh: Binding<Bool>, collectionId: String, documentId: String){
        _viewModel = StateObject(wrappedValue: DetailViewModel(appwrite: appwrite))
        _updateViewModel = StateObject(wrappedValue: UpdateViewModel(appwrite: appwrite))
        _triggerRefresh = triggerRefresh
        self.appwrite = appwrite
        self.collectionId = collectionId
        self.documentId = documentId
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                NameBackgroundView()
                Group {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .controlSize(.large)
                    } else {
                        VStack {
                            VStack{
                                //Display the pet name:
                                CardView(name: viewModel.detailsModel?.name ?? "")
                                //Display the protocol date:
                                Text("Protocol Date: \(viewModel.formattedStringDate)")
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
            }
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing,
                        content: {
                Button("Update"){
                    showUpdateForm = true
                }
                //Displays the update form:
                .sheet(isPresented: $showUpdateForm,
                       onDismiss: {
                    if noteUpdated {
                        viewModel.fetchDocument(collectionId: collectionId, documentId: documentId)
                        noteUpdated = false
                    }},
                       content: {UpdateView(appwrite: appwrite, triggerRefresh: $triggerRefresh, noteUpdated: $noteUpdated, collectionId: collectionId, documentId: documentId)}
                )
            })
            ToolbarItem(placement: .topBarTrailing,
                        content: {
                Button("Delete"){
                    Task {
                        viewModel.deleteNote(collectionId: collectionId, documentId: documentId)
                        noteDeleted = true
                        dismiss.callAsFunction()
                    }
                }
                .foregroundStyle(Color.red)
            })
        }
        .task {
            viewModel.modelSetup(detailsModel)
            viewModel.fetchDocument(collectionId: collectionId, documentId: documentId)
        }
        .onDisappear{
            if noteDeleted {
                triggerRefresh = true
            }
        }
    }
}

struct NameBackgroundView: View {
    
    var body: some View {
        Color("NameBackground")//custom color with dark mode support
            .ignoresSafeArea(.all)
    }
}

//#Preview {
//    @Previewable var previewAppwrite = Appwrite()
//    DetailView(appwrite: previewAppwrite, triggerRefresh: .constant(false), collectionId: "66a04db400070bffec78", documentId: "6799d9ab2ce631c69eee")
//}
