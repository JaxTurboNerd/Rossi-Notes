//
//  UpdateForm.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct UpdateView: View {
    
    @StateObject var viewModel = UpdateViewModel()
    @StateObject var noteDetails: DetailsModel
    @Binding var triggerRefresh: Bool
    @Binding var triggerUpdate: Bool
    
    var collectionId = ""
    var documentId = ""
    
    
    //Used to dismiss the form:
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name/Date")
                    .font(Font.custom("Urbanist-Medium", size: 16))
                    .foregroundColor(Color("AppBlue")))
                {
                    TextField("Name", text: $noteDetails.name)
                    DatePicker("Protocol Date", selection: $noteDetails.protocolDate, displayedComponents: [.date])//shows only the date excludes time
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
                    Button{
                        //action:
                        
                    } label: {
                        Text("Submit")
                            .frame(maxWidth: 250)
                            .font(.headline)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    
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
                            viewModel.updateProtocol(collectionId: collectionId, documentId: documentId, noteDetails: noteDetails)
                            triggerUpdate = true
                            dismiss.callAsFunction()
                        }
                    }
                })
            }
        }
    }
    
}

//#Preview {
//    UpdateView()
//}
