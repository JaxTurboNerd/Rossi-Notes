//
//  DetailViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/28/24.
//

import SwiftUI
import Foundation
import Appwrite
import JSONCodable

class DetailViewModel: ObservableObject {
    let appwrite = Appwrite()
    
    //@Published var detailsData: DetailsModel?
    @Published var document: Document<[String: AnyCodable]>?
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var detailsData: DetailsModel?
    
    @State var noteDeleted = false
    
    private let databaseId = "66a04cba001cb48a5bd7"
    
    public func fetchDocument(collectionId: String ,documentId: String){
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await appwrite.databases.getDocument(
                    databaseId: self.databaseId,
                    collectionId: collectionId,
                    documentId: documentId,
                    queries: [] // optional
                )
                    self.document = response
                    self.isLoading = false                
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    //will need to rework from a Date object?
   private func formatDate(from dateString: String) -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = .withFullDate
        let formatedDate = isoDateFormatter.date(from: dateString) ?? Date.now
        
        //Non-ISO Date formatting, which is what is needed?
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        return dateFormatter.string(from: formatedDate)
    }


    
//    private func decodeResponse(response: Dictionary<String, AnyCodable>){
//        //assign response data values to the data model:
//        detailsData.id = response["$id"]?.value as! String
//        detailsData.name = response["name"]?.value as! String
//        detailsData.miscNotes = response["misc_notes"]?.value as! String
//        //let date = response["protocol_date"]?.value as! String
//        detailsData.protocolDate = response["protocol_date"]?.value as! Date
//        detailsData.dogReactive = ((response["dog_reactive"]?.value) != nil)
//        detailsData.barrierReactive = ((response["barrier_reactive"]?.value) != nil)
//        detailsData.catReactive = ((response["cat_reactive"]?.value) != nil)
//        detailsData.jumpyMouthy = ((response["jumpy_mouthy"]?.value) != nil)
//        detailsData.resourceGuarder = ((response["resource_guarder"]?.value) != nil)
//        detailsData.strangerReactive = ((response["stranger_reactive"]?.value) != nil)
//        detailsData.leashReactive = ((response["leash_reactive"]?.value) != nil)
//        detailsData.placeRoutine = ((response["place_routing"]?.value) != nil)
//        detailsData.doorRoutine = ((response["door_routing"]?.value) != nil)
//        
////        for(key, value) in response {
////            if (value == true){
////                switch key {
////                case "leash_reactive":
////                    detailsData.leashReactive = "Leash Reactive"
////                case "cat_reactive":
////                    detailsData.catReactive = "Cat Reactive"
////                case "resource_guarder":
////                    detailsData.resourceGuarder = "Resource Guarder"
////                case "stranger_reactive":
////                    detailsData.strangerReactive = "Stranger Reactive"
////                case "door_routine":
////                    detailsData.doorRoutine = "Practice Door Routine"
////                case "barrier_reactive":
////                    detailsData.barrierReactive = "Barrier Reactive"
////                case "dog_reactive":
////                    detailsData.dogReactive = "Dog Reactive"
////                case "place_routine":
////                    detailsData.placeRoutine = "Practice Place Routine"
////                case "jumpy_mouthy":
////                    detailsData.jumpyMouthy = "Jumpy/Mouthy"
////                default:
////                    return
////                    
////                }
////            }
////        }
//    }
    
    
    
    public func deleteNote(collectionId: String, documentId: String){
        Task {
            do {
                let successfulDelete = try await appwrite.databases.deleteDocument(
                    databaseId: self.databaseId,
                    collectionId: collectionId,
                    documentId: documentId
                    )
                await MainActor.run {
                    //do stuff here:
                    noteDeleted = true
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    print("delete document error \(String(describing: errorMessage))")
                    self.isLoading = false
                }
            }
        }
    }
}
