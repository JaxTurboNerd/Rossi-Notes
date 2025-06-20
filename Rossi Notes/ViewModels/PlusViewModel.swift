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
                    isLoading = true
                }
                throw FetchDocumentsError.failedFetch
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
            print("fetch document error \(error.localizedDescription)")
            throw FetchDocumentsError.failedFetch
        }
    }
    
    @MainActor
    func refreshDocuments() async throws {
        do {
            try await fetchDocuments()
        } catch {
            print("referesh error: \(error.localizedDescription)")
            throw FetchDocumentsError.failedFetch
        }
    }
}
