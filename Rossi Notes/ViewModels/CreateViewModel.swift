//
//  CreateProtocolViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 1/9/25.
//

import Foundation
import Appwrite
import JSONCodable

@MainActor
final class CreateViewModel: ObservableObject {
    private let appwrite: Appwrite
    
    @Published var document: Document<[String: AnyCodable]>?
    @Published var documentId = ID.unique()
    @Published var name = ""
    @Published var protocolDate = Date.now
    @Published var dogReactive = false
    @Published var catReactive = false
    @Published var barrierReactive = false
    @Published var leashReactive = false
    @Published var jumpy = false
    @Published var resourceGuarder = false
    @Published var avoidStrangers = false
    @Published var placeRoutine = false
    @Published var doorRoutine = false
    @Published var looseLeash = false
    @Published var notes = ""
    @Published public var isSubmitting = false
    @Published public var errorMessage: String?
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    @MainActor
    func createProtocol(collectionId: String) async throws {
        isSubmitting = true
        errorMessage = nil
        
        let newProtocol = Protocol(name: name, protocol_date: protocolDate, dog_reactive: dogReactive, cat_reactive: catReactive, barrier_reactive: barrierReactive, leash_reactive: leashReactive, jumpy_mouthy: jumpy, resource_guarder: resourceGuarder, stranger_reactive: avoidStrangers, place_routine: placeRoutine, door_routine: doorRoutine, misc_notes: notes)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let data = try? encoder.encode(newProtocol) else {
                self.isSubmitting = false
                throw JSONError.invalidData
            }
            
            //convert data to json string:
            let dataString = String(data: data, encoding: .utf8)
            guard let response = try await appwrite.createDocument(collectionId, documentId, dataString ?? "") else {
                self.isSubmitting = false
                throw CreateProtocolError.failedToCreateProtocol
            }
            self.document = response
            self.isSubmitting = false
            
        } catch JSONError.invalidData {
            self.isSubmitting = false
            
        } catch JSONError.typeMismatch {
            self.isSubmitting = false
            
        } catch CreateProtocolError.failedToCreateProtocol {
            self.isSubmitting = false
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
