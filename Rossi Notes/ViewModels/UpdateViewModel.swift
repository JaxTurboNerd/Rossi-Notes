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
    var noteDetails: DetailsModel?
    
    @Published public var isSubmitting = false
    @Published public var errorMessage: String?
    @Published var document: Document<[String: AnyCodable]>?
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    public func modelSetup(_ model: DetailsModel){
        self.noteDetails = model
    }
    
    func updateProtocol(collectionId: String, documentId: String, noteDetails: DetailsModel) async throws {
        isSubmitting = true
        errorMessage = nil
        
        let updatedProtocol = Protocol(name: noteDetails.name, protocol_date: noteDetails.protocolDate, dog_reactive: noteDetails.dogReactive, cat_reactive: noteDetails.catReactive, barrier_reactive: noteDetails.barrierReactive, leash_reactive: noteDetails.leashReactive, jumpy_mouthy: noteDetails.jumpyMouthy, resource_guarder: noteDetails.resourceGuarder, stranger_reactive: noteDetails.strangerReactive, place_routine: noteDetails.placeRoutine, door_routine: noteDetails .doorRoutine, shy_fearful: noteDetails.shyFearful, misc_notes: noteDetails.miscNotes)
        
        do {
            let encoder = JSONEncoder()
            encoder.dateEncodingStrategy = .iso8601
            guard let data = try? encoder.encode(updatedProtocol) else {return}
            
            //convert data to json string:
            guard let dataString = String(data: data, encoding: .utf8) else {
                self.errorMessage = "Invalid Data error.  Please try again"
                return
            }
            let response = try await appwrite.updateDocument(collectionId, documentId, dataString)
            self.document = response
            self.isSubmitting = false
            
        } catch {
            self.errorMessage = error.localizedDescription
            print("Create document error \(String(describing: errorMessage))")
            self.isSubmitting = false
            
        }
    }
}

