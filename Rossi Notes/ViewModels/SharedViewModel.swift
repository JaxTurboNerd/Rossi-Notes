//
//  SharedViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 4/13/25.
//

import SwiftUI
import Appwrite
import JSONCodable

@MainActor
final class SharedViewModel: ObservableObject {
    @Published public var documents: [Document<[String: AnyCodable]>] = []  //Protocol Docs
    @Published public var plusDocuments: [Document<[String: AnyCodable]>] = [] //Plus Docs
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    @Published public var noteAdded = false
    
    // Constants
    let appwrite: Appwrite
    private let databaseId = "66a04cba001cb48a5bd7"
    let collectionId = "66a04db400070bffec78"
    let plusCollectionId = "66a402a0003ddfe36884"
    
    
    //Protocol Detail variables:
    var document: Document<[String: AnyCodable]>?
    var documentId = ID.unique()
    var name = ""
    var protocolDate = Date.now
    var dogReactive = false
    var catReactive = false
    var barrierReactive = false
    var leashReactive = false
    var jumpy = false
    var resourceGuarder = false
    var avoidStrangers = false
    var placeRoutine = false
    var doorRoutine = false
    var looseLeash = false
    var notes = ""
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
        Task {
            try await fetchProtocolDocuments()
            try await fetchPlusDocuments()
        }
    }
    
    func fetchProtocolDocuments() async throws {
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
    
    func fetchPlusDocuments() async throws {
        self.isLoading = true
        self.errorMessage = nil
        
        do {
            let response = try await appwrite.listDocuments(plusCollectionId)
            self.plusDocuments = response?.documents ?? []
            self.isLoading = false
        } catch {
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            print("fetch document error \(error.localizedDescription)")
        }
    }
    
    func refreshProtocolDocuments() async throws {
        do {
            try await fetchProtocolDocuments()
        } catch {
            print("refresh error \(error.localizedDescription)")
        }
        
    }
    
    func refreshPlusDocuments() async throws {
        do {
            try await fetchPlusDocuments()
        } catch {
            print("refresh error \(error.localizedDescription)")
        }
        
    }
    
    func createProtocol(collectionId: String) async throws {
        isLoading = true
        errorMessage = nil
        
        let newProtocol = Protocol(name: name, protocol_date: protocolDate, dog_reactive: dogReactive, cat_reactive: catReactive, barrier_reactive: barrierReactive, leash_reactive: leashReactive, jumpy_mouthy: jumpy, resource_guarder: resourceGuarder, stranger_reactive: avoidStrangers, place_routine: placeRoutine, door_routine: doorRoutine, misc_notes: notes)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let data = try? encoder.encode(newProtocol) else {
                self.isLoading = false
                throw JSONError.invalidData
            }
            
            //convert data to json string:
            let dataString = String(data: data, encoding: .utf8)
            guard (try await appwrite.createDocument(collectionId, documentId, dataString ?? "")) != nil else {
                self.isLoading = false
                throw CreateProtocolError.failedToCreateProtocol
            }
            //self.document = response
            self.noteAdded = true
            self.isLoading = false
            
        } catch JSONError.invalidData {
            self.isLoading = false
            
        } catch JSONError.typeMismatch {
            self.isLoading = false
            
        } catch CreateProtocolError.failedToCreateProtocol {
            self.isLoading = false
        }
    }
}

enum CreateProtocolError: LocalizedError {
    case failedToCreateProtocol
    
    var errorDescription: String? {
        switch self {
        case .failedToCreateProtocol:
            return "Failed to create protocol.  Please try again."
        }
    }
}

enum JSONError: LocalizedError {
    case invalidData
    case typeMismatch
    
    var errorDescription: String? {
        switch self {
        case .invalidData:
            return "Invalid data"
        case .typeMismatch:
            return "Type mismatch"
        }
    }
}
