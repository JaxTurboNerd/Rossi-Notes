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

final class UpdateViewModel: ObservableObject {
    let appwrite = Appwrite()
    
    @Published public var isSubmitting = false
    @Published public var errorMessage: String?
    @Published var document: Document<[String: AnyCodable]>?

    //@Published var noteDetails: DetailsModel
    
    private let databaseId = "66a04cba001cb48a5bd7"
    
    func updateProtocol(collectionId: String, documentId: String, noteDetails: DetailsModel){
        isSubmitting = true
        errorMessage = nil
        
        let updatedProtocol = Protocol(name: noteDetails.name, protocol_date: noteDetails.protocolDate, dog_reactive: noteDetails.dogReactive, cat_reactive: noteDetails.catReactive, barrier_reactive: noteDetails.barrierReactive, leash_reactive: noteDetails.leashReactive, jumpy_mouthy: noteDetails.jumpyMouthy, resource_guarder: noteDetails.resourceGuarder, stranger_reactive: noteDetails.strangerReactive, place_routine: noteDetails.placeRoutine, door_routine: noteDetails .doorRoutine, misc_notes: noteDetails.miscNotes)
        
        Task {
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                guard let data = try? encoder.encode(updatedProtocol) else {return}
               
                //convert data to json string:
                let dataString = String(data: data, encoding: .utf8)
                let response = try await appwrite.databases.updateDocument(
                    databaseId: databaseId,
                    collectionId: collectionId,
                    documentId: documentId,
                    data: dataString as Any //required JSON Object
                )
                self.document = response
                await MainActor.run {
                    self.isSubmitting = false
                }
            
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    print("Create document error \(String(describing: errorMessage))")
                    self.isSubmitting = false
                }
            }
        }
    }
}

