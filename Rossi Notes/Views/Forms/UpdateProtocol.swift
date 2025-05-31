//
//  UpdateForm.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct UpdateView: View {
    
    @StateObject private var viewModel: UpdateViewModel
    @EnvironmentObject var noteDetails: DetailsModel
    @EnvironmentObject private var refresh: Refresh
    @Binding var noteUpdated: Bool
    @Binding var isPlusNote: Bool
    @State private var alertMessage = ""
    @State private var showAlert = false
    @FocusState var nameIsFocused: Bool
    private var alertTitle: String {noteUpdated ? "Note Updated" : "Error"}
    
    var collectionId: String
    var documentId: String
    
    //Used to dismiss the form:
    @Environment(\.dismiss) private var dismiss
    
    //view initializer:
    init(appwrite: Appwrite, noteUpdated: Binding<Bool>, collectionId: String, documentId: String, isPlusNote: Binding<Bool>, refresh: Refresh){
        _viewModel = StateObject(wrappedValue: UpdateViewModel(appwrite: appwrite, isPlusNote: isPlusNote))
        _noteUpdated = noteUpdated
        _isPlusNote = isPlusNote
        self.collectionId = collectionId
        self.documentId = documentId
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name/Date")
                    .font(Font.custom("Urbanist-ExtraBold", size: 16))
                    .foregroundColor(Color("SectionTitleColor")))
                {
                    TextField("Name", text: $noteDetails.name).focused($nameIsFocused)
                    DatePicker("Protocol Date", selection: $noteDetails.protocolDate, displayedComponents: [.date])//shows only the date excludes time
                        .datePickerStyle(.compact)
                    Button(isPlusNote ? "Protocol" : "Protocol +", systemImage: isPlusNote ? "arrow.down" : "arrow.up", action: {
                        Task {
                            do {
                                try await viewModel.changeProtocolLevel(originalCollectionID: collectionId, originalDocumentID: documentId, noteDetails: noteDetails)
                                noteUpdated = true
                                alertMessage = "\(noteDetails.name) Protocol Level Updated"
                                refresh.triggerRefresh = true
                                showAlert = true
                            } catch {
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                    })
                }
                Section(header: Text("Reactivities")
                    .font(Font.custom("Urbanist-ExtraBold", size: 16))
                    .foregroundColor(Color("SectionTitleColor")))
                {
                    Toggle("Barrier", isOn: $noteDetails.barrierReactive)
                    Toggle("Dog", isOn: $noteDetails.dogReactive)
                    Toggle("Leash", isOn: $noteDetails.leashReactive)
                    Toggle("Cat", isOn: $noteDetails.catReactive)
                }
                Section(header: Text("Tools")
                    .font(Font.custom("Urbanist-ExtraBold", size: 16))
                    .foregroundColor(Color("SectionTitleColor")))
                {
                    Toggle("Dragline", isOn: $noteDetails.dragline)
                    Toggle("Chain Leash", isOn: $noteDetails.chainLeash)
                    Toggle("Harness", isOn: $noteDetails.harness)
                    Toggle("Gentle Leader", isOn: $noteDetails.gentleLeader)
                }
                Section(header: Text("Miscellaneous")
                    .font(Font.custom("Urbanist-ExtraBold", size: 16))
                    .foregroundColor(Color("SectionTitleColor")))
                {
                    Toggle("Loose Leash", isOn: $noteDetails.looseLeash)
                    Toggle("Jumpy/Mouthy", isOn: $noteDetails.jumpyMouthy)
                    Toggle("Resource Guarder", isOn: $noteDetails.resourceGuarder)
                    Toggle("Avoid Strangers", isOn: $noteDetails.strangerReactive)
                    Toggle("Door Routine", isOn: $noteDetails.doorRoutine)
                    Toggle("Shy/Fearful", isOn: $noteDetails.shyFearful)
                }
                Section(header: Text("Notes")
                    .font(Font.custom("Urbanist-ExtraBold", size: 16))
                    .foregroundColor(Color("SectionTitleColor")))
                {
                    TextField("Notes", text: $noteDetails.miscNotes, axis: .vertical)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading, content: {
                    Button("Dismiss"){
                        //Dismiss the form
                        dismiss.callAsFunction()
                    }
                    .foregroundColor(.red)
                })
                ToolbarItem(placement: .topBarTrailing, content: {
                    Button("Update"){
                        Task {
                            //Submit the form:
                            do {
                                let isValidFields = try validateTextFields(name: noteDetails.name, date: noteDetails.protocolDate)
                                if isValidFields {
                                    do {
                                        try await viewModel.updateProtocol(collectionId: collectionId, documentId: documentId, noteDetails: noteDetails)
                                        noteUpdated = true
                                        alertMessage = "\(noteDetails.name) Updated!"
                                        showAlert = true
                                    } catch {
                                        viewModel.isSubmitting = false
                                        alertMessage = "Failed to update protocol. Please try again."
                                        showAlert = true
                                    }
                                }
                            } catch UpdateTextfieldError.nameIsEmpty {
                                nameIsFocused = true
                                alertMessage = "Name is required."
                                showAlert = true
                            } catch UpdateTextfieldError.dateIsEmpty {
                                alertMessage = "Date is required."
                                showAlert = true
                            }
                        }
                    }
                })
            }
            .task {
                viewModel.modelSetup(noteDetails)
            }
            .alert(isPresented: $showAlert){
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")){
                    dismiss.callAsFunction()
                })
            }
        }
    }
}

enum UpdateTextfieldError: Error {
    case nameIsEmpty, dateIsEmpty
}

private func validateTextFields(name: String, date: Date) throws -> Bool {
    if name.isEmpty {
        throw UpdateTextfieldError.nameIsEmpty
    }
    return true
}

class Refresh: ObservableObject {
    @Published var triggerRefresh: Bool = false
    @Published var protocolLevelChanged: Bool = false
}

#Preview {
    @Previewable var previewAppwrite = Appwrite()
    UpdateView(appwrite: previewAppwrite, noteUpdated: .constant(false), collectionId: "xxxx", documentId: "cxlks", isPlusNote: .constant(false), refresh: Refresh())
        .environmentObject(DetailsModel())
}
