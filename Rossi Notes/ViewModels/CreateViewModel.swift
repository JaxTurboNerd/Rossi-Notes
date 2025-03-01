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
    
    //private let databaseId = "66a04cba001cb48a5bd7"
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    func createProtocol(collectionId: String){
        isSubmitting = true
        errorMessage = nil
        
        let newProtocol = Protocol(name: name, protocol_date: protocolDate, dog_reactive: dogReactive, cat_reactive: catReactive, barrier_reactive: barrierReactive, leash_reactive: leashReactive, jumpy_mouthy: jumpy, resource_guarder: resourceGuarder, stranger_reactive: avoidStrangers, place_routine: placeRoutine, door_routine: doorRoutine, misc_notes: notes)
        
        Task {
            do {
                let encoder = JSONEncoder()
                encoder.dateEncodingStrategy = .iso8601
                guard let data = try? encoder.encode(newProtocol) else {return}
               
                //convert data to json string:
                let dataString = String(data: data, encoding: .utf8)
//                let response = try await appwrite.databases.createDocument(
//                    databaseId: databaseId,
//                    collectionId: collectionId,
//                    documentId: documentId,
//                    data: dataString as Any //required JSON Object
//                )
                let response = try await appwrite.createDocument(collectionId, documentId, dataString ?? "")
                await MainActor.run {
                    self.document = response
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
