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
    
    //Probably don't need these to be @Published:
    @Published public var isSubmitting = false
    @Published public var noteAdded = false
    
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
    var shyFearful = false
    var notes = ""
    var createdBy = ""
    //var updatedBy = ""
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    @MainActor
    func createProtocol(collectionId: String) async throws {
        isSubmitting = true
        
        if let userName = appwrite.currentUser?.name {
            self.createdBy = userName
        }
        
        let newProtocol = Protocol(name: name, protocol_date: protocolDate, dog_reactive: dogReactive, cat_reactive: catReactive, barrier_reactive: barrierReactive, leash_reactive: leashReactive, jumpy_mouthy: jumpy, resource_guarder: resourceGuarder, stranger_reactive: avoidStrangers, place_routine: placeRoutine, door_routine: doorRoutine, looseLeash: looseLeash, shy_fearful: shyFearful, misc_notes: notes, created_by: createdBy)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let data = try? encoder.encode(newProtocol) else {
                self.isSubmitting = false
                throw JSONError.invalidData
            }
            
            //convert data to json string:
            guard let dataString = String(data: data, encoding: .utf8) else {
                throw CreateProtocolError.failedToCreateProtocol
            }
            let _ = try await appwrite.createDocument(collectionId, documentId, dataString)
            self.noteAdded = true
            self.isSubmitting = false
            
        } catch JSONError.invalidData {
            self.isSubmitting = false
            throw JSONError.invalidData
            
        } catch JSONError.typeMismatch {
            self.isSubmitting = false
            throw JSONError.typeMismatch
            
        } catch CreateProtocolError.failedToCreateProtocol {
            self.isSubmitting = false
            throw CreateProtocolError.failedToCreateProtocol
            
        } catch {
            print("Create VM Error: \(error.localizedDescription)")
            self.isSubmitting = false
            throw CreateProtocolError.failedToCreateProtocol
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
