//
//  ProtocolForm.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct CreateView: View {
    
    @StateObject private var viewModel: CreateViewModel
    @State private var noteAdded = false
    @State private var alertMessage = ""
    @State private var showAlert = false
    @Binding var triggerRefresh: Bool
    @Binding var isPlusNote: Bool
    @FocusState var nameIsFocused: Bool
    var collectionId: String
    private var alertTitle: String { noteAdded ? "Note Added!" : "Error" }
    @State private var shouldDismiss: Bool = false
    
    //Used to dismiss the form:
    @Environment(\.dismiss) private var dismiss
    
    init(appwrite: Appwrite, collectionId: String, triggerRefresh: Binding<Bool>, isPlusNote: Binding<Bool>){
        _viewModel = StateObject(wrappedValue: CreateViewModel(appwrite: appwrite))
        self.collectionId = collectionId
        _triggerRefresh = triggerRefresh
        _isPlusNote = isPlusNote
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(
                    header:Text("Name/Date")
                        .font(Font.custom("Urbanist-ExtraBold", size: 16))
                        .foregroundColor(Color("SectionTitleColor")))
                {
                    VStack {
                        TextField("Name", text: $viewModel.name).focused($nameIsFocused)
                    }
                    
                    DatePicker("Protocol Date", selection: $viewModel.protocolDate, displayedComponents: [.date])//shows only the date excludes time
                        .datePickerStyle(.compact)
                }
                Section(header: Text("Reactivities")
                    .font(Font.custom("Urbanist-ExtraBold", size: 16))
                    .foregroundColor(Color("SectionTitleColor")))
                {
                    Toggle("Barrier", isOn: $viewModel.barrierReactive)
                    Toggle("Dog", isOn: $viewModel.dogReactive)
                    Toggle("Leash", isOn: $viewModel.leashReactive)
                    Toggle("Cat", isOn: $viewModel.catReactive)
                }
                Section(header: Text("Tools")
                    .font(Font.custom("Urbanist-ExtraBold", size: 16))
                    .foregroundColor(Color("SectionTitleColor")))
                {
                    Toggle("Dragline", isOn: $viewModel.dragline)
                    Toggle("Chain Leash", isOn: $viewModel.chainLeash)
                    Toggle("Harness", isOn: $viewModel.harness)
                    Toggle("Gentle Leader", isOn: $viewModel.gentleLeader)
                }
                Section(header: Text("Miscellaneous")
                    .font(Font.custom("Urbanist-ExtraBold", size: 16))
                    .foregroundColor(Color("SectionTitleColor")))
                {
                    Toggle("Loose Leash", isOn: $viewModel.looseLeash)
                    Toggle("Jumpy/Mouthy", isOn: $viewModel.jumpy)
                    Toggle("Resource Guarder", isOn: $viewModel.resourceGuarder)
                    Toggle("Avoid Strangers", isOn: $viewModel.avoidStrangers)
                    Toggle("Door Routine", isOn: $viewModel.doorRoutine)
                    Toggle("Shy/Fearful", isOn: $viewModel.shyFearful)
                }
                Section(header: Text("Notes")
                    .font(Font.custom("Urbanist-ExtraBold", size: 16))
                    .foregroundColor(Color("SectionTitleColor")))
                {
                    TextField("Notes", text: $viewModel.notes, axis: .vertical)
                }
            }
            .onTapGesture {
                self.dismissKeyboard()
            }
            .navigationTitle(isPlusNote ? "Protocol +" : "Protocol")
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
                    Button("Submit"){
                        Task {
                            //Submit the form:
                            do {
                                let isValidFields = try validateTextFields(name: viewModel.name, date: viewModel.protocolDate)
                                if isValidFields {
                                    do {
                                        try await viewModel.createProtocol(collectionId: collectionId)
                                        noteAdded = true
                                        alertMessage = "Note added successfully!"
                                        shouldDismiss = true
                                        showAlert = true
                                    } catch {
                                        viewModel.isSubmitting = false
                                        alertMessage = error.localizedDescription
                                        showAlert = true
                                    }
                                }
                            } catch CreateTextfieldError.nameIsEmpty {
                                nameIsFocused = true
                                alertMessage = "Name is required."
                                showAlert = true
                            } catch CreateTextfieldError.dateIsEmpty {
                                alertMessage = "Date is required."
                                showAlert = true
                            }
                        }
                    }
                })
            }
            .onDisappear {
                if noteAdded {
                    triggerRefresh = true
                }
            }
            .alert(isPresented: $showAlert){
                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")){shouldDismiss ? dismiss.callAsFunction() : nil})
            }
        }
    }
}

enum CreateTextfieldError: Error {
    case nameIsEmpty, dateIsEmpty
}

private func validateTextFields(name: String, date: Date) throws -> Bool {
    //let dateFormatter = DateFormatter()
    if name.isEmpty {
        throw CreateTextfieldError.nameIsEmpty
    }
    return true
}

