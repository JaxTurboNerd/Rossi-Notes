//
//  DetailView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/28/24.
//

import SwiftUI

struct DetailView: View {
    private var appwrite: Appwrite
    var collectionId: String
    var documentId: String
    
    @StateObject private var viewModel: DetailViewModel
    @StateObject private var updateViewModel: UpdateViewModel
    @EnvironmentObject private var detailsModel: DetailsModel
    @EnvironmentObject private var refresh: Refresh
    @State private var showUpdateForm: Bool = false
    @State private var showPopover: Bool = false
    @State private var showAlert: Bool = false
    //    @State private var isDeleteAlert: Bool = false
    //    @State private var isArchiveAlert: Bool = false
    @State private var activeAlert: ActiveAlert = .defaultAlert
    
//    private var alertTitle: String {self.activeAlert == .delete ? "Confirm Delete" : self.activeAlert == .archive ? "Confirm Archive?" : "Update Failed"}
    private var alertTitle: String {
        switch activeAlert {
        case .delete:
            return "Confirm Delete"
        case .archive:
            return "Confirm Archive?"
        case .failedToDelete:
            return "Failed To Delete"
        case .failedToArchive:
            return "Failed To Archive"
        default:
            return "Error"
        }
    }
    //Do not move the two lines below up near the other @State vars (causes odd errors):
    @Binding var isPlusNote: Bool
    @State var noteUpdated = false
    
    //Used to dismiss the form:
    @Environment(\.dismiss) private var dismiss
    
    
    init(appwrite: Appwrite, collectionId: String, documentId: String, isPlusNote: Binding<Bool>){
        _viewModel = StateObject(wrappedValue: DetailViewModel(appwrite: appwrite))
        _updateViewModel = StateObject(wrappedValue: UpdateViewModel(appwrite: appwrite, isPlusNote: isPlusNote))
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
                        Text("Failed to load protocol.  \nPlease try again later.")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                    } else {
                        VStack {
                            ScrollView {
                                VStack{
                                    //Display the pet name:
                                    CardView(name: viewModel.detailsModel?.name ?? "Error")
                                        .popover(isPresented: $showPopover) {
                                            VStack {
                                                Text("Change to:")
                                                    .padding(.bottom, 10)
                                                Divider()
                                                Button(isPlusNote ? "Protocol" : "Protocol +", systemImage: isPlusNote ? "arrow.down" : "arrow.up") {
                                                    Task {
                                                        do {
                                                            try await updateViewModel.changeProtocolLevel(originalCollectionID: collectionId, originalDocumentID: documentId, noteDetails: viewModel.detailsModel!)
                                                            noteUpdated = true
                                                            refresh.triggerRefresh = true
                                                            showPopover = false
                                                            dismiss.callAsFunction()
                                                        } catch {
                                                            print("\(error.localizedDescription)")
                                                            self.activeAlert = .delete
                                                            //isDeleteAlert = false
                                                            //Need to alert the user of a failed change:
                                                            showAlert = true
                                                        }
                                                    }
                                                }
                                                .padding(.top, 10)
                                            }
                                            .frame(width: 200, height: 100)
                                            .padding(20)
                                            .presentationCompactAdaptation(.popover)
                                        }
                                    HStack { //Display the protocol date:
                                        Image(uiImage: viewModel.creatorImage ?? UIImage(systemName: "person.circle")!)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 35, height: 35)
                                            .clipShape(.circle)
                                            .padding(.leading, 10)
                                        Spacer()
                                        VStack {
                                            Group {
                                                Text("Protocol Date:")
                                                Text(" \(viewModel.formattedStringDate)")
                                            }
                                            .font(.system(size: 22))
                                            .fontWeight(.bold)
                                            .padding(.leading, -45)
                                        }
                                        Spacer()
                                        //Possibly for the Update User initials image:
                                        //                                        Image(uiImage: viewModel.creatorImage ?? UIImage(systemName: "person.circle")!)
                                        //                                            .resizable()
                                        //                                            .scaledToFit()
                                        //                                            .frame(width: 35, height: 35)
                                        //                                            .clipShape(.circle)
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
            //Displays the update form:
            .sheet(isPresented: $showUpdateForm,
                   onDismiss: {
                if noteUpdated {
                    Task {
                        //need do/catch:
                        do {
                            try await viewModel.fetchDocument(collectionId: collectionId, documentId: documentId)
                        } catch {
                            print("fetch document error: \(error.localizedDescription)")
                            //view model will throw and error and set .failedToFetch = true
                            //so probably no need to show another alert to notify the user the delete failed
                        }
                    }
                    noteUpdated = false
                }},
                   content: {UpdateView(appwrite: appwrite, noteUpdated: $noteUpdated, collectionId: collectionId, documentId: documentId, isPlusNote: $isPlusNote, refresh: refresh)}
            )
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                Menu("Update") {
                    Button("Update Details", systemImage: "square.and.pencil"){
                        showUpdateForm = true
                    }
                    Button("Update Protocol Level", systemImage: "arrow.up.arrow.down"){
                        showPopover = true
                    }
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Menu("Delete"){
                    Button("Archive", systemImage: "archivebox"){
                        self.activeAlert = .archive
                        showAlert = true
                    }
                    Button("Delete", systemImage: "trash"){
                        self.activeAlert = .delete
                        showAlert = true
                    }
                }
                .foregroundStyle(Color.red)
                .alert(alertTitle, isPresented: $showAlert, actions: {
                    switch self.activeAlert {
                    case .delete:
                        Button("Delete", role: .destructive){
                            Task {
                                do {
                                    try await viewModel.deleteNote(collectionId: collectionId, documentId: documentId)
                                    dismiss.callAsFunction()
                                    refresh.triggerRefresh = true
                                } catch {
                                    print("delete document error: \(error.localizedDescription)")
                                    //alert the user of a failed delete:
                                    self.activeAlert = .failedToDelete
                                    showAlert = true
                                }
                            }
                            dismiss.callAsFunction()
                        }
                        Button("Cancel", role: .cancel){
                            //action:
                        }
                    case .archive:
                        Button("Archive", role: .destructive){
                            Task {
                                do {
                                    try await viewModel.archiveProtocol(originalCollectionID: collectionId, originalDocumentID: documentId, noteDetails: viewModel.detailsModel!)
                                    refresh.triggerRefresh = true
                                } catch {
                                    print("archive document error: \(error.localizedDescription)")
                                    //alert user of the failed archive:
                                    self.activeAlert = .failedToArchive
                                    showAlert = true
                                }
                            }
                            dismiss.callAsFunction()
                        }
                    case .failedToDelete, .failedToArchive, .defaultAlert:
                        Button("OK"){
                            dismiss.callAsFunction()
                        }
                    }
                })
            }
        }
        .task {
            viewModel.modelSetup(detailsModel)
            do {
                try await viewModel.fetchDocument(collectionId: collectionId, documentId: documentId)
            } catch {
                print("fetching document error: \(error.localizedDescription)")
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

enum ActiveAlert {
    case delete, archive, defaultAlert, failedToDelete, failedToArchive
    
//    var alertTitle: String? {
//        switch self {
//        case .delete: return "Delete"
//        case .archive: return "Archive"
//        case .failedToDelete: return "Failed to delete"
//        case .failedToArchive: return "Failed to archive"
//        case .defaultAlert: return "Error"
//        }
//    }
}

#Preview {
    @Previewable var previewAppwrite = Appwrite()
    DetailView(appwrite: previewAppwrite, collectionId: "xxxxxxxxxx", documentId: "6799d9ab2ce631c69eee", isPlusNote: .constant(false))
        .environmentObject(DetailsModel())
}
