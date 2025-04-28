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
    let appwrite: Appwrite
    
    // Published properties for UI updates
    @Published public var documents: [Document<[String: AnyCodable]>] = []
    @Published public var isLoading = false
    @Published public var errorMessage: String?
    
    // Constants
    var collectionId: String {
        do {
            let IdKey: String = try Configuration.value(for: "PROTOCOL_COLL_ID")
            return IdKey
        } catch {
            print("error getting collection id")
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
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let response = try await appwrite.listDocuments(collectionId)
            self.documents = response?.documents ?? []
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            print("fetch document error \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func refreshDocuments() async throws {
        do {
            try await fetchDocuments()
        } catch {
            print("refresh error \(error.localizedDescription)")
        }
        
    }
}
