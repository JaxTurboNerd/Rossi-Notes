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
    @Binding var triggerRefresh: Bool
    @Binding var noteUpdated: Bool
    @State private var alertMessage = ""
    @State private var showAlert = false
    
    var collectionId: String
    var documentId: String
    
    //Used to dismiss the form:
    @Environment(\.dismiss) private var dismiss
    
    //view initializer:
    init(appwrite: Appwrite, triggerRefresh: Binding<Bool>, noteUpdated: Binding<Bool>, collectionId: String, documentId: String){
        _viewModel = StateObject(wrappedValue: UpdateViewModel(appwrite: appwrite))
        _triggerRefresh = triggerRefresh
        _noteUpdated = noteUpdated
        self.collectionId = collectionId
        self.documentId = documentId
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name/Date")
                    .font(Font.custom("Urbanist-Medium", size: 16))
                    .foregroundColor(Color("AppBlue")))
                {
                    TextField("Name", text: $noteDetails.name)
                    DatePicker("Protocol Date", selection: $noteDetails.protocolDate, displayedComponents: [.date])//shows only the date excludes time
                        .datePickerStyle(.compact)
                }
                Section(header: Text("Reactivities")
                    .font(Font.custom("Urbanist-Medium", size: 16))
                    .foregroundColor(Color("AppBlue")))
                {
                    Toggle("Dog", isOn: $noteDetails.dogReactive)
                    Toggle("Cat", isOn: $noteDetails.catReactive)
                    Toggle("Barrier", isOn: $noteDetails.barrierReactive)
                    Toggle("Leash", isOn: $noteDetails.leashReactive)
                }
                Section(header: Text("Miscellaneous")
                    .font(Font.custom("Urbanist-Medium", size: 16))
                    .foregroundColor(Color("AppBlue")))
                {
                    Toggle("Jumpy/Mouthy", isOn: $noteDetails.jumpyMouthy)
                    Toggle("Resource Guarder", isOn: $noteDetails.resourceGuarder)
                    Toggle("Avoid Strangers", isOn: $noteDetails.strangerReactive)
                    Toggle("Door Routine", isOn: $noteDetails.doorRoutine)
                }
                Section(header: Text("Notes")
                    .font(Font.custom("Urbanist-Medium", size: 16))
                    .foregroundColor(Color("AppBlue")))
                {
                    TextField("Notes", text: $noteDetails.miscNotes, axis: .vertical)
                }
            }
            .navigationTitle("Protocol")
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
                                try await viewModel.updateProtocol(collectionId: collectionId, documentId: documentId, noteDetails: noteDetails)
                                noteUpdated = true
                                dismiss.callAsFunction()

                            } catch {
                                viewModel.isSubmitting = false
                                alertMessage = error.localizedDescription
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
                Alert(title: Text("Create Protocol"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
}
