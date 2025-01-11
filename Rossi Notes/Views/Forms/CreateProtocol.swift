//
//  ProtocolForm.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct CreateProtocolForm: View {
    
    @StateObject private var viewModel = CreateProtocolViewModel()
    
    //Used to dismiss the form:
    @Environment(\.dismiss) private var dismiss
    var collectionId: String
    
    var body: some View {
        NavigationStack {
            Form {
                Section(
                    header:Text("Name/Date")
                        .font(Font.custom("Urbanist-Medium", size: 16))
                        .foregroundColor(Color("AppBlue")))
                {
                    TextField("Name", text: $viewModel.name)
                    DatePicker("Protocol Date", selection: $viewModel.protocolDate, displayedComponents: [.date])//shows only the date excludes time
                }
                Section(header: Text("Reactivities")
                    .font(Font.custom("Urbanist-Medium", size: 16))
                    .foregroundColor(Color("AppBlue")))
                {
                    Toggle("Dog", isOn: $viewModel.dogReactive)
                    Toggle("Cat", isOn: $viewModel.catReactive)
                    Toggle("Barrier", isOn: $viewModel.barrierReactive)
                    Toggle("Leash", isOn: $viewModel.leashReactive)
                }
                Section(header: Text("Miscellaneous")
                    .font(Font.custom("Urbanist-Medium", size: 16))
                    .foregroundColor(Color("AppBlue")))
                {
                    Toggle("Jumpy/Mouthy", isOn: $viewModel.jumpy)
                    Toggle("Resource Guarder", isOn: $viewModel.resourceGuarder)
                    Toggle("Avoid Strangers", isOn: $viewModel.avoidStrangers)
                    Toggle("Door Routine", isOn: $viewModel.doorRoutine)
                    Toggle("Loose Leash", isOn: $viewModel.looseLeash)
                }
                Section(header: Text("Notes")
                    .font(Font.custom("Urbanist-Medium", size: 16))
                    .foregroundColor(Color("AppBlue")))
                {
                    TextField("Notes", text: $viewModel.notes, axis: .vertical)
                    Button{
                        //action:
                        viewModel.createProtocol(collectionId: collectionId)
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
            .onTapGesture {
                self.dismissKeyboard()
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
                    Button("Submit"){
                        //Submit the form:
                        viewModel.createProtocol(collectionId: collectionId)
                    }
                })
            }
//            .onSubmit {
//                viewModel.createProtocol(collectionId: collectionId)
//            }
        }
    }
}

//#Preview {
//    CreateProtocolForm()
//}
