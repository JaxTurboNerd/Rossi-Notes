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
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @State var noteDeleted = false
    @Published var detailsModel = DetailsModel()

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
                    self.isLoading = false
                setDetailsModel(response: response)
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
    
    private func setDetailsModel(response: Document<[String: AnyCodable]>){
        detailsModel.id = response.data["$id"]?.value as! String
        detailsModel.name = response.data["name"]?.value as! String
        detailsModel.protocolDate = response.data["protocol_date"]?.value as! Date
        detailsModel.jumpyMouthy = response.data["jumpy_mouthy"]?.value as! Bool
        detailsModel.dogReactive = response.data["dog_reactive"]?.value as! Bool
        detailsModel.catReactive = response.data["cat_reactive"]?.value as! Bool
        detailsModel.leashReactive = response.data["leash_reactive"]?.value as! Bool
        detailsModel.barrierReactive = response.data["barrier_reactive"]?.value as! Bool
        detailsModel.doorRoutine = response.data["door_routine"]?.value as! Bool
        detailsModel.placeRoutine = response.data["place_routine"]?.value as! Bool
        detailsModel.resourceGuarder = response.data["resource_guarder"]?.value as! Bool
        detailsModel.strangerReactive = response.data["stranger_reactive"]?.value as! Bool
        detailsModel.miscNotes = response.data["misc_notes"]?.value as! String
    }
    
    
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
