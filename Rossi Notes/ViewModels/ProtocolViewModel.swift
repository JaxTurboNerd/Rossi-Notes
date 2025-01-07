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
    let appwrite = Appwrite()
    
    // Published properties for UI updates
    @Published public var documents: [Document<[String: AnyCodable]>] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    // Constants
    private let databaseId = "66a04cba001cb48a5bd7"
    let collectionId = "66a04db400070bffec78"
    
    func fetchDocuments() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await appwrite.databases.listDocuments(
                    databaseId: databaseId,
                    collectionId: collectionId,
                    queries: []
                )
                //returns response of type: DocumentList<Dictionary<String, AnyCodable>>
                await MainActor.run {
                    self.documents = response.documents
                    self.isLoading = false
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
