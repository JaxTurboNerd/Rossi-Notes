//
//  UpdateViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 1/16/25.
//

//
//  CreateProtocolViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 1/9/25.
//

import Foundation
import Appwrite
import SwiftUICore
import JSONCodable


@MainActor
final class UpdateViewModel: ObservableObject {
    private let appwrite: Appwrite
    private var createdBy = ""
    var noteDetails: DetailsModel?
    
    @Published public var isSubmitting = false
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    public func modelSetup(_ model: DetailsModel){
        self.noteDetails = model
    }
    
    func updateProtocol(collectionId: String, documentId: String, noteDetails: DetailsModel) async throws {
        isSubmitting = true
        
        if let userName = appwrite.currentUser?.name {
            self.createdBy = userName
        }
        
        let updatedProtocol = Protocol(name: noteDetails.name, protocol_date: noteDetails.protocolDate, dog_reactive: noteDetails.dogReactive, cat_reactive: noteDetails.catReactive, barrier_reactive: noteDetails.barrierReactive, leash_reactive: noteDetails.leashReactive, jumpy_mouthy: noteDetails.jumpyMouthy, resource_guarder: noteDetails.resourceGuarder, stranger_reactive: noteDetails.strangerReactive, place_routine: noteDetails.placeRoutine, door_routine: noteDetails .doorRoutine, loose_leash: noteDetails.looseLeash, shy_fearful: noteDetails.shyFearful, dragline: noteDetails.dragline, chain_leash: noteDetails.chainLeash, harness: noteDetails.harness, gentle_leader: noteDetails.gentleLeader, misc_notes: noteDetails.miscNotes, created_by: createdBy)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let data = try? encoder.encode(updatedProtocol) else {
                self.isSubmitting = false
                throw JSONError.invalidData
            }
            
            //convert data to json string:
            guard let dataString = String(data: data, encoding: .utf8) else {
                throw UpdateProtocolError.failedToUpdateProtocol
            }
            let _ = try await appwrite.updateDocument(collectionId, documentId, dataString)
            self.isSubmitting = false
            
        } catch JSONError.invalidData {
            self.isSubmitting = false
            
        } catch JSONError.typeMismatch {
            self.isSubmitting = false
            
        } catch UpdateProtocolError.failedToUpdateProtocol {
            print("Update VM error")
            self.isSubmitting = false
        } catch let error as AppwriteError {
            print("Update error: \(String(describing: error.type))")
            if error.type == "user_unauthorized" {
                throw AuthError.unauthorized
            } else {
                throw UpdateProtocolError.failedToUpdateProtocol
            }
        }
    }
}

enum UpdateProtocolError: LocalizedError {
    case failedToUpdateProtocol
    
    var errorDescription: String? {
        switch self {
        case .failedToUpdateProtocol:
            return "Failed to  update.  Please try again."
        }
    }
}

