//
//  ProtocolViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/17/24.
//

import SwiftUI
import Appwrite
import JSONCodable

struct Protocol: Codable, Identifiable {
    let id: String
    let name: String
    let dogReactive: Bool
    let barrierReactive: Bool
    let miscNotes: String
    let protocolDate: Date
    let catReactive: Bool
    let resourceGuarder: Bool
    let strangerReactive: Bool
    let jumpyMouthy: Bool
    let doorRoutine: Bool
    let placeRoutine: Bool
    let leashReactive: Bool
    let creatorName: String
}


class ProtocolViewModel: ObservableObject {
    private let client: Client
    private let databases: Databases
    
    // Published properties for UI updates
    @Published public var documents: [Document<[String: AnyCodable]>] = []
    @Published public var sampleDocuments: [String] = []
    @Published public var sampleResponse: String = ""
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    // Constants
    private let databaseId = "66a04cba001cb48a5bd7"
    private let collectionId = "66a04db400070bffec78"
    //private let sampleData: Protocol
    
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
                //returns response of type: DocumentList<Dictionary<String, AnyCodable>>
                //print(String(describing: response.toMap()))
                await MainActor.run {
                    self.documents = response.documents
                    self.isLoading = false
                    self.sampleResponse = String(describing: response.toMap())
                    //print(sampleResponse)
                    //Prints: 'Optional("Peanut")
                    //print(String(describing: documents[0].data["name"]?.value))
                }
                //print(type(of: documents[0].data))//Dictionary<String: AnyCodable>
                let sampleData = documents[0].data
                let sampleName = documents[0].data["name"]
//                print("sample data: \(sampleName ?? "no name")")
//                print("sample data 2: \(documents[0].data["leash_reactive"] ?? "no value")")
                //iterate over the data dictionary:
                for (key, value) in sampleData {
                    print("Key: \(key) value is: \(value)")
                    //key value type = String, value type = AnyCodable
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
