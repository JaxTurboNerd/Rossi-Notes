//
//  ProtocolView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI
import Foundation
import Appwrite

struct ProtocolView: View {
    
    @State private var showForm = false
    @State private var numOfNotes = 0
    @State private var notes = []
    @StateObject var database = Appwrite()
    private var protocolCollectionId = "66a04db400070bffec78"
    
    //Need to add navigation bar items on the top of the view
    var body: some View {
        NavigationView {
            List(0..<numOfNotes, id: \.self){_ in
                CardView()
            }
            .navigationTitle("Protocol")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing,
                            content: {
                    Button("Add Note"){
                        showForm = true
                    }
                    //Displays the protocol form to create a new note
                    .sheet(isPresented: $showForm, content: {ProtocolForm()})
                })
            }
            .task {
                await loadData()
            }
        }
    }
    
    private func loadData() async {
        do {
            let protocolNotes = try await database.getNotesList(protocolCollectionId)
            numOfNotes = protocolNotes.total //works
            self.notes = protocolNotes.documents
            let note = String(describing: protocolNotes.documents[0].toMap())
            //print("documents one: \(type(of: note))")//works -> String
            
            //testing code to get appwrite reponse to json object:
            if let jsonData = note.data(using: .utf8){
                do {
                    if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
                        print(jsonObject)
                    }
                } catch {
                    print("error parsing: \(error)")
                }
            }
            
            DispatchQueue.main.async {
                let response = String(describing: protocolNotes.toMap())
            }
        } catch {
            print("get protocol notes error: \(error)")
            DispatchQueue.main.async {
                let response = error.localizedDescription
            }
        }
    }
}

#Preview {
    ProtocolView()
}
