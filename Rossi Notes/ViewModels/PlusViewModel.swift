//
//  PlusViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/28/24.
//

import SwiftUI
import Appwrite
import JSONCodable

class PlusViewModel: ObservableObject {
    let appwrite: Appwrite

    // Published properties for UI updates
    @Published public var documents: [Document<[String: AnyCodable]>] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    // Constants
    var collectionId: String {
        do {
            let IdKey: String = try Configuration.value(for: "PLUS_COLL_ID")
            return IdKey
        } catch {
            print("collection ID error")
            return ""
        }
    }
    
    //Initialize:
    init(appwrite: Appwrite){
        self.appwrite = appwrite
        Task {
            try await fetchDocuments()
        }
    }
    
    @MainActor
    func fetchDocuments() async throws {
        isLoading = true
        errorMessage = nil
            do {
                let response = try await appwrite.listDocuments(collectionId)
                //returns response of type: DocumentList<Dictionary<String, AnyCodable>>
                    self.documents = response!.documents
                    self.isLoading = false
                
            } catch {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
            }
    }
    
    @MainActor
    func refreshDocuments() async throws {
        do {
            try await fetchDocuments()
        } catch {
            print("referesh error: \(error.localizedDescription)")
        }
    }
}
