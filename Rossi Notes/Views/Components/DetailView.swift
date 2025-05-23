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
    @State private var showUpdateForm: Bool = false
    @State private var showAlert: Bool = false
    @State private var showNamePopover: Bool = false
    private var appwrite: Appwrite
    
    var collectionId: String
    var documentId: String
    //Do not move the two lines below up near the other @State vars (causes odd errors):
    @Binding var triggerRefresh: Bool
    @Binding var isPlusNote: Bool
    @State private var noteDeleted = false
    @State var noteUpdated = false
    
    //Used to dismiss the form:
    @Environment(\.dismiss) private var dismiss
    
    init(appwrite: Appwrite, triggerRefresh: Binding<Bool>, collectionId: String, documentId: String, isPlusNote: Binding<Bool>){
        _viewModel = StateObject(wrappedValue: DetailViewModel(appwrite: appwrite))
        _updateViewModel = StateObject(wrappedValue: UpdateViewModel(appwrite: appwrite, isPlusNote: isPlusNote))
        _triggerRefresh = triggerRefresh
        _isPlusNote = isPlusNote
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
                    } else if viewModel.failedToFetch {
                        Text("Failed to load protocol.")
                            .font(.headline)
                    } else {
                        ScrollView {
                            VStack {
                                VStack{
                                    //Display the pet name:
                                    CardView(name: viewModel.detailsModel?.name ?? "Error")
                                    //Display the protocol date:
                                    HStack {
                                        Image(uiImage: viewModel.creatorImage ?? UIImage(systemName: "person.circle")!)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 35, height: 35)
                                            .clipShape(.circle)
                                        Text("Protocol Date: \(viewModel.formattedStringDate)")
                                            .font(.system(size: 20))
                                            .fontWeight(.bold)
                                            .padding(.vertical)
                                    }
                                    //Details:
                                    DetailGroupView(viewModel: viewModel)
                                }
                                .padding()
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10).stroke(Color("AppBlue"), lineWidth: 1)
                                        .shadow(color: Color("AppBlue").opacity(0.4), radius: 2, x: 2, y: 2)
                                )
                                .background(Color("BackgroundMain"))
                                Spacer()
                            }
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
                        Task {
                            //need do/catch:
                            try await viewModel.fetchDocument(collectionId: collectionId, documentId: documentId)
                        }
                        noteUpdated = false
                    }},
                       content: {UpdateView(appwrite: appwrite, noteUpdated: $noteUpdated, collectionId: collectionId, documentId: documentId, isPlusNote: $isPlusNote)}
                )
            })
            ToolbarItem(placement: .topBarTrailing,
                        content: {
                Button("Delete"){
                    showAlert = true
                }
                .foregroundStyle(Color.red)
            })
        }
        .alert("Confirm Deletion", isPresented: $showAlert, actions: {
            Button("Delete", role: .destructive){
                Task {
                    try await viewModel.deleteNote(collectionId: collectionId, documentId: documentId)
                    noteDeleted = true
                }
                dismiss.callAsFunction()
            }
            Button("Cancel", role: .cancel){
                //action:
            }
        })
        .task {
            viewModel.modelSetup(detailsModel)
            do {
                try await viewModel.fetchDocument(collectionId: collectionId, documentId: documentId)
            } catch {
                print("fetching document error: \(error.localizedDescription)")
            }
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

#Preview {
    @Previewable var previewAppwrite = Appwrite()
    DetailView(appwrite: previewAppwrite, triggerRefresh: .constant(false), collectionId: "xxxxxxxxxx", documentId: "6799d9ab2ce631c69eee", isPlusNote: .constant(false))
        .environmentObject(DetailsModel())
}
