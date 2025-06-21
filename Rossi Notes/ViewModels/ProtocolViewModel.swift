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
    @Published public var showAlert = false
    @Published public var alertMessage: String = ""
    
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
        self.isLoading = true
        Task {
            do {
                try await fetchDocuments()
                await MainActor.run {
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    //self.isLoading = false
                    alertMessage = error.localizedDescription //will show the AuthError description
                    showAlert = true
                }
            }
        }
        isLoading = false
    }
    
    @MainActor
    func fetchDocuments() async throws {
        self.isLoading = true
        do {
            let response = try await appwrite.listDocuments(collectionId)
            self.documents = response?.documents ?? []
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.alertMessage = error.localizedDescription
            self.showAlert = true
        }
    }
    
    @MainActor
    func refreshDocuments() async throws {
        do {
            try await fetchDocuments()
            self.isLoading = false
        } catch {
            self.isLoading = false
            self.alertMessage = error.localizedDescription
            self.showAlert = true
        }
        
    }
}
