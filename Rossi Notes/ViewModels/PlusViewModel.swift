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
    
    @Published public var documents: [Document<[String: AnyCodable]>] = []
    @Published public var isLoading = false
    @Published public var showAlert = false
    @Published public var alertMessage: String = ""
    
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
            do {
                try await fetchDocuments()
                await MainActor.run {
                    self.isLoading = false
                }
            } catch {
                print("fetching document error: \(error.localizedDescription)")
                await MainActor.run {
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
                throw AppwriteDocumentError.failedToFetchDocuments
            }
        }
    }
    
    @MainActor
    func fetchDocuments() async throws {
        isLoading = true
        do {
            let response = try await appwrite.listDocuments(collectionId)
            //returns response of type: DocumentList<Dictionary<String, AnyCodable>>
            self.documents = response!.documents
            self.isLoading = false
            
        } catch {
            self.isLoading = false
            self.alertMessage = error.localizedDescription
            self.showAlert = true
        }
    }
    
    @MainActor
    func refreshDocuments() async throws {
        self.isLoading = true
        do {
            try await fetchDocuments()
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.alertMessage = error.localizedDescription
            self.showAlert = true        }
    }
}
