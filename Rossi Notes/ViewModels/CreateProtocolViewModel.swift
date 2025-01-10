//
//  CreateProtocolViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 1/9/25.
//

import Foundation

final class CreateProtocolViewModel: ObservableObject {
    let appwrite = Appwrite()
    var collectionId: String
    var documentId: String

    @Published public var isSubmitting = false
    @Published public var errorMessage: String?
    
    private let databaseId = "66a04cba001cb48a5bd7"
    
    init(collectionId: String, documentId: String){
        self.collectionId = collectionId
        self.documentId = documentId
    }
    
    func createProtocol(){
        isSubmitting = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await appwrite.databases.createDocument(
                    databaseId: databaseId,
                    collectionId: collectionId,
                    documentId: documentId,
                    data: [:]//required JSON Object
                )
                
                await MainActor.run {
                    //self.documents = response.documents
                    self.isSubmitting = false
                }
            
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    print("get document error \(String(describing: errorMessage))")
                    self.isSubmitting = false
                }
            }
        }
    }
}
