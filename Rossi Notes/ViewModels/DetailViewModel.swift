//
//  DetailViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/28/24.
//

import SwiftUI
import Foundation
import Appwrite
import JSONCodable

class DetailViewModel: ObservableObject {
    private let client: Client
    private let databases: Databases
    
    //@Published var protocolDetails: [ProtocolDetails] = []
    @Published var detailsData = DetailsModel()
    @Published var document: Document<[String: AnyCodable]>?
    @Published var isLoading = false
    @Published public var errorMessage: String?
    
    // Constants
    private let databaseId = "66a04cba001cb48a5bd7"

    public var collectionID = ""
    
    init() {
        // Initialize Appwrite client
        client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("66a04859001d3df0988d")
        
        databases = Databases(client)
    }
    
    public func fetchDocument(collectionId: String ,documentId: String){
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await databases.getDocument(
                    databaseId: self.databaseId,
                    collectionId: collectionId,
                    documentId: documentId,
                    queries: [] // optional
                )
                await MainActor.run {
                    self.document = response
                    self.isLoading = false
                    //protocolDetails?.name = document?.data["name"]?.value as! String //works
                    decodeResponse(response: document!.data)
                }
                
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func decodeResponse(response: Dictionary<String, AnyCodable>){
        //print("decode response for name: \(response["name"]?.value as! String)") //works: Priscilla
        //assign response data values to the data model:
        detailsData.id = response["$id"]?.value as! String
        detailsData.name = response["name"]?.value as! String
        detailsData.miscNotes = response["misc_notes"]?.value as! String
        let date = response["protocol_date"]?.value as! String
        detailsData.formatDate(from: date)
        //print(detailsData.protocolDate = detailsData.formatDate(from: date) ?? Date())
    }
}
