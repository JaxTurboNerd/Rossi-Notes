//
//  ProtocolForm.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct ProtocolForm: View {
    
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
    @State var notes = ""
    
    var body: some View {
        Form {
            Section {
                Text("Name")
                TextField("Name", text: $name)
                DatePicker("protocol date", selection: $protocolDate, displayedComponents: [.date])//shows only the date excludes time
            }
            Section(header: Text("Reactivities")) {
                Toggle("Dog", isOn: $dogReactive)
                Toggle("Cat", isOn: $catReactive)
                Toggle("Barrier", isOn: $barrierReactive)
                Toggle("Leash", isOn: $leashReactive)
            }
            Section(header: Text("Miscellaneous")){
                Toggle("Jumpy/Mouthy", isOn: $jumpy)
                Toggle("Resource Guarder", isOn: $resourceGuarder)
                Toggle("Avoid Strangers", isOn: $avoidStrangers)
                Toggle("Door Routine", isOn: $doorRoutine)
            }
            Section(header: Text("Notes")){
                TextField("Notes", text: $notes, axis: .vertical)
            }
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
}

#Preview {
    ProtocolForm()
}
