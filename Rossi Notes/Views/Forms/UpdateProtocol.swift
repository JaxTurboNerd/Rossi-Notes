//
//  UpdateForm.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct UpdateView: View {
    
    @StateObject var viewModel: UpdateViewModel
    @EnvironmentObject var noteDetails: DetailsModel
    @Binding var noteUpdated: Bool
    @State private var alertMessage = ""
    @State private var showAlert = false
    @FocusState var nameIsFocused: Bool
    private var alertTitle: String {noteUpdated ? "Note Updated" : "Error"}
    
    var collectionId: String
    var documentId: String
    
    //Used to dismiss the form:
    @Environment(\.dismiss) private var dismiss
    
    //view initializer:
    init(appwrite: Appwrite, noteUpdated: Binding<Bool>, collectionId: String, documentId: String){
        _viewModel = StateObject(wrappedValue: UpdateViewModel(appwrite: appwrite))
        _noteUpdated = noteUpdated
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
                    VStack {
                        TextField("Name", text: $noteDetails.name).focused($nameIsFocused)
                    }
                    DatePicker("Protocol Date", selection: $noteDetails.protocolDate, displayedComponents: [.date])//shows only the date excludes time
                        .datePickerStyle(.compact)
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
                                        alertMessage = "Failed to update protocol. Please try again later."
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
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")){dismiss.callAsFunction()})
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
