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

final class UpdateViewModel: ObservableObject {
    let appwrite = Appwrite()
    
    @Published public var isSubmitting = false
    @Published public var errorMessage: String?
    @Published var noteDetails: DetailsModel
    
    private let databaseId = "66a04cba001cb48a5bd7"
    
    init(data: DetailsModel){
        self.noteDetails = data
    }
    
    func updateProtocol(collectionId: String, documentId: String){
        isSubmitting = true
        errorMessage = nil
        
        //not working:  all values are the default values:
        let updateProtocol = Protocol(name: noteDetails.name, protocol_date: noteDetails.protocolDate, dog_reactive: noteDetails.dogReactive, cat_reactive: noteDetails.catReactive, barrier_reactive: noteDetails.barrierReactive, leash_reactive: noteDetails.leashReactive, jumpy_mouthy: noteDetails.jumpyMouthy, resource_guarder: noteDetails.resourceGuarder, stranger_reactive: noteDetails.strangerReactive, place_routine: noteDetails.placeRoutine, door_routine: noteDetails .doorRoutine, misc_notes: noteDetails.miscNotes)
        
        Task {
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                guard let data = try? encoder.encode(updateProtocol) else {return}
               
                //convert data to json string:
                let dataString = String(data: data, encoding: .utf8)
                let response = try await appwrite.databases.updateDocument(
                    databaseId: databaseId,
                    collectionId: collectionId,
                    documentId: documentId,
                    data: dataString as Any //required JSON Object
                )
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

