//
//  ProtocolViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/17/24.
//

import SwiftUI
import Appwrite
import JSONCodable

final class ProtocolViewModel: ObservableObject {
    private let client: Client
    private let databases: Databases
    
    // Published properties for UI updates
    @Published public var documents: [Document<[String: AnyCodable]>] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    // Constants
    private let databaseId = "66a04cba001cb48a5bd7"
    let collectionId = "66a04db400070bffec78"
    
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
                    //self.sampleResponse = String(describing: response.toMap()) //returns a String literal
                    //print(type(of: sampleResponse))
                    //print(String(describing: documents[0].data["name"]?.value)) //prints: Optional("Peanut")
                    //print(type(of: documents[0].data))//Dictionary<String: AnyCodable>
//                    let sampleName = documents[0].data["name"]
//                    print("sample name: \(sampleName ?? "No name")")
                    //let sampleName = documents[0].data["name"]
                    //print("sample data: \(sampleName ?? "no name")") //prints: Peanut
                    //print("sample data 2: \(documents[0].data["leash_reactive"] ?? "no value")") //prints: false
                    //iterate over the data dictionary:
                    //let sampleData = documents[0].data
                    //let createDate = documents[0].data["$createdAt"]
                    //print("created date: \(createDate ?? "")")
                }
                
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    print("get document error \(String(describing: errorMessage))")
                    self.isLoading = false
                }
            }
        }
    }
    
    func refreshDocuments() {
        fetchDocuments()
    }
}
