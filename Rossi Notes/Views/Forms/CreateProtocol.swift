//
//  ProtocolForm.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct CreateProtocolForm: View {
    
    @State var name = ""
    @State var protocolDate = Date.now
    @State var dogReactive = false
    @State var catReactive = false
    @State var barrierReactive = false
    @State var leashReactive = false
    @State var jumpy = false
    @State var resourceGuarder = false
    @State var avoidStrangers = false
    @State var placeRoutine = false
    @State var doorRoutine = false
    @State var looseLeash = false
    @State var notes = ""
    
    //Used to dismiss the form:
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section(
                    header:Text("Name/Date")
                        .font(Font.custom("Urbanist-Medium", size: 16))
                        .foregroundColor(Color("AppBlue")))
                {
                    TextField("Name", text: $name)
                    DatePicker("Protocol Date", selection: $protocolDate, displayedComponents: [.date])//shows only the date excludes time
                }
                Section(header: Text("Reactivities")
                    .font(Font.custom("Urbanist-Medium", size: 16))
                    .foregroundColor(Color("AppBlue")))
                {
                    Toggle("Dog", isOn: $dogReactive)
                    Toggle("Cat", isOn: $catReactive)
                    Toggle("Barrier", isOn: $barrierReactive)
                    Toggle("Leash", isOn: $leashReactive)
                }
                Section(header: Text("Miscellaneous")
                    .font(Font.custom("Urbanist-Medium", size: 16))
                    .foregroundColor(Color("AppBlue")))
                {
                    Toggle("Jumpy/Mouthy", isOn: $jumpy)
                    Toggle("Resource Guarder", isOn: $resourceGuarder)
                    Toggle("Avoid Strangers", isOn: $avoidStrangers)
                    Toggle("Door Routine", isOn: $doorRoutine)
                    Toggle("Loose Leash", isOn: $looseLeash)
                }
                Section(header: Text("Notes")
                    .font(Font.custom("Urbanist-Medium", size: 16))
                    .foregroundColor(Color("AppBlue")))
                {
                    TextField("Notes", text: $notes, axis: .vertical)
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
                    }
                })
            }
        }
    }
}

#Preview {
    CreateProtocolForm()
}
