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
    @Binding var isPlusNote: Bool
    @EnvironmentObject private var refresh: Refresh
    
    init(appwrite: Appwrite, isPlusNote: Binding<Bool>){
        self.appwrite = appwrite
        _isPlusNote = isPlusNote
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
        }
    }
    
    public func changeProtocolLevel(originalCollectionID: String, originalDocumentID: String, noteDetails: DetailsModel) async throws {
        //Determine which collection API key to use:
        var collectionId: String {
            do {
                //isPlusNote value is from the collection BEFORE moving it to the other collection
                //so need to flip/flop the collection id..ie: Plus -> Protocol
                if isPlusNote {
                    let IdKey: String = try Configuration.value(for: "PROTOCOL_COLL_ID")
                    return IdKey
                } else {
                    let idKey: String = try Configuration.value(for: "PLUS_COLL_ID")
                    return idKey
                }
            } catch {
                print("error getting collection id")
                return ""
            }
        }
        
        let protcol = Protocol(name: noteDetails.name, protocol_date: noteDetails.protocolDate, dog_reactive: noteDetails.dogReactive, cat_reactive: noteDetails.catReactive, barrier_reactive: noteDetails.barrierReactive, leash_reactive: noteDetails.leashReactive, jumpy_mouthy: noteDetails.jumpyMouthy, resource_guarder: noteDetails.resourceGuarder, stranger_reactive: noteDetails.strangerReactive, place_routine: noteDetails.placeRoutine, door_routine: noteDetails.doorRoutine, loose_leash: noteDetails.looseLeash, shy_fearful: noteDetails.shyFearful, dragline: noteDetails.dragline, chain_leash: noteDetails.chainLeash, harness: noteDetails.harness, gentle_leader: noteDetails.gentleLeader, misc_notes: noteDetails.miscNotes, created_by: noteDetails.createdBy)
        
        //convert protocol details to data object:
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let data = try? encoder.encode(protcol) else {
                self.isSubmitting = false
                throw JSONError.invalidData
            }
            
            //convert data to json string:
            guard let dataString = String(data: data, encoding: .utf8) else {
                throw UpdateProtocolError.failedToChangeProtocolLevel
            }
            //Need to pass in the other collection id to the createDocument func:
            let _ = try await appwrite.createDocument(collectionId, ID.unique(), dataString)
            self.isSubmitting = false
            
        } catch JSONError.invalidData {
            self.isSubmitting = false
            
        } catch JSONError.typeMismatch {
            self.isSubmitting = false
            
        } catch UpdateProtocolError.failedToChangeProtocolLevel {
            self.isSubmitting = false
        } catch {
            self.isSubmitting = false
            throw UpdateProtocolError.failedToChangeProtocolLevel
        }
        
        //Deleted the "Old" document:
        do {
            try await appwrite.deleteDocument(originalCollectionID, originalDocumentID)
            refresh.triggerRefresh = true
        } catch {
            print("Error deleting old document")
            throw UpdateProtocolError.failedToChangeProtocolLevel
        }
    }
}

enum UpdateProtocolError: LocalizedError {
    case failedToUpdateProtocol, failedToChangeProtocolLevel
    
    var errorDescription: String? {
        switch self {
        case .failedToUpdateProtocol:
            return "Failed to  update.  Please try again."
        case .failedToChangeProtocolLevel:
            return "Failed to change the protocol level.  Please try again."
        }
    }
}

