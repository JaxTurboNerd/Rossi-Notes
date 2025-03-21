//
//  PlusViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/28/24.
//

import SwiftUI
import Appwrite
import JSONCodable

@MainActor
class PlusViewModel: ObservableObject {
    private let appwrite: Appwrite

    // Published properties for UI updates
    @Published public var documents: [Document<[String: AnyCodable]>] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    // Constants
    private let databaseId = "66a04cba001cb48a5bd7"
    let collectionId = "66a402a0003ddfe36884"
    
    //Initialize:
    init(appwrite: Appwrite){
        self.appwrite = appwrite
        fetchDocuments()
    }
    
    func fetchDocuments() {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await appwrite.listDocuments(collectionId)
                //returns response of type: DocumentList<Dictionary<String, AnyCodable>>
                await MainActor.run {
                    self.documents = response!.documents
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
}
