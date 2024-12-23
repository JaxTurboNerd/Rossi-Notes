//
//  ProtocolViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/17/24.
//

import SwiftUI
import Appwrite
import JSONCodable

class ProtocolViewModel: ObservableObject {
    private let client: Client
    private let databases: Databases
    
    // Published properties for UI updates
    @Published var documents: [Document<[String: AnyCodable]>] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // Constants
    private let databaseId = "66a04cba001cb48a5bd7"
    private let collectionId = "66a04db400070bffec78"
    
    init() {
        // Initialize Appwrite client
        client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("66a04859001d3df0988d")
        
        databases = Databases(client)
    }
    
    func fetchDocuments() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await databases.listDocuments(
                    databaseId: databaseId,
                    collectionId: collectionId,
                    queries: []
                )
                print("Response: \(response)")
                await MainActor.run {
                    self.documents = response.documents
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    func refreshDocuments() {
        fetchDocuments()
    }
    
    //    private func loadData() async {
    //        do {
    //            let protocolNotes = try await database.getNotesList(protocolCollectionId)
    //            numOfNotes = protocolNotes.total //works
    //            self.notes = protocolNotes.documents
    //            let note = String(describing: protocolNotes.documents[0].toMap())
    //            //print("note: \(String(describing: note.data(using: .utf8)))")
    //
    //            //testing code to get appwrite reponse to json object:
    //            if let jsonData = note.data(using: .utf8){
    //                do {
    //                    if let jsonObject = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String: Any] {
    //                        print(jsonObject)
    //                    }
    //                } catch {
    //                    print("error parsing: \(error)")
    //                }
    //            }
    //
    //            DispatchQueue.main.async {
    //                let response = String(describing: protocolNotes.toMap())
    //            }
    //        } catch {
    //            print("get protocol notes error: \(error)")
    //            DispatchQueue.main.async {
    //                let response = error.localizedDescription
    //            }
    //        }
    //    }
    
}
