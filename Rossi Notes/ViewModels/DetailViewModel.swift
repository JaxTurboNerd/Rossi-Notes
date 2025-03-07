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

@MainActor
class DetailViewModel: ObservableObject {
    private let appwrite: Appwrite
    var detailsModel: DetailsModel?
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var document: Document<[String: AnyCodable]>?
    //This model used to display string values from the details model:
    @ObservedObject var detailsStringModel = DetailsStringModel()
    @Published var formattedStringDate = ""
    @State var noteWillDelete = false

    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    //This function is intended to inject an instance of the DetailsModel:
    public func modelSetup(_ model: DetailsModel){
        self.detailsModel = model
    }
    
    public func fetchDocument(collectionId: String ,documentId: String){
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let document = try await appwrite.listDocument(collectionId, documentId)
                self.document = document
                await MainActor.run {
                    self.isLoading = false
                    setDetailsModel(response: document!)
                    formattedStringDate = formatDate(from: detailsModel?.protocolDate ?? Date.now)
                    setDetailsStringModel(responseData: document!.data)
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                    
                }
            }
        }
    }
    
    //formats the date string value to a formatted value of the Month/DD/YYYY:
    private func formatDate(from date: Date) -> String {
        //Non-ISO Date formatting, which is what is needed?
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        //return dateFormatter.string(from: formattedDate)
        return dateFormatter.string(from: date)
    }
    
    //Used to convert the response date string value to type Date:
    private func formatDateString(from dateString: String) -> Date {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.formatOptions = .withFullDate
        let formattedDate = isoDateFormatter.date(from: dateString) ?? Date.now
        
        return formattedDate
    }
    
    private func setDetailsModel(response: Document<[String: AnyCodable]>){
        //formats the response date value (string) to a Date object:
        let protocolDateObject = formatDateString(from: response.data["protocol_date"]?.value as! String)
        //set the detailsModel instance values;
        //detailsModel.id = response.data["$id"]?.value as! String
        detailsModel?.name = response.data["name"]?.value as! String
        detailsModel?.protocolDate = protocolDateObject
        detailsModel?.jumpyMouthy = response.data["jumpy_mouthy"]?.value as! Bool
        detailsModel?.dogReactive = response.data["dog_reactive"]?.value as! Bool
        detailsModel?.catReactive = response.data["cat_reactive"]?.value as! Bool
        detailsModel?.leashReactive = response.data["leash_reactive"]?.value as! Bool
        detailsModel?.barrierReactive = response.data["barrier_reactive"]?.value as! Bool
        detailsModel?.doorRoutine = response.data["door_routine"]?.value as! Bool
        detailsModel?.placeRoutine = response.data["place_routine"]?.value as! Bool
        detailsModel?.resourceGuarder = response.data["resource_guarder"]?.value as! Bool
        detailsModel?.strangerReactive = response.data["stranger_reactive"]?.value as! Bool
        detailsModel?.miscNotes = response.data["misc_notes"]?.value as! String
    }
    
    //This function sets the string values from the api response to a model instance to be
    //displayed in the DetailLineView:
    private func setDetailsStringModel(responseData: Dictionary<String, AnyCodable>){
        //assign response data values to the data model:
        detailsStringModel.id = responseData["$id"]?.value as! String
        detailsStringModel.name = responseData["name"]?.value as! String
        detailsStringModel.miscNotes = responseData["misc_notes"]?.value as! String
        let date = responseData["protocol_date"]?.value as! String
        detailsStringModel.protocolDate = detailsStringModel.formatDate(from: date)
        
        for(key, value) in responseData {
            if (value == true){
                switch key {
                case "leash_reactive":
                    detailsStringModel.leashReactive = "Leash Reactive"
                case "cat_reactive":
                    detailsStringModel.catReactive = "Cat Reactive"
                case "resource_guarder":
                    detailsStringModel.resourceGuarder = "Resource Guarder"
                case "stranger_reactive":
                    detailsStringModel.strangerReactive = "Stranger Reactive"
                case "door_routine":
                    detailsStringModel.doorRoutine = "Practice Door Routine"
                case "barrier_reactive":
                    detailsStringModel.barrierReactive = "Barrier Reactive"
                case "dog_reactive":
                    detailsStringModel.dogReactive = "Dog Reactive"
                case "place_routine":
                    detailsStringModel.placeRoutine = "Practice Place Routine"
                case "jumpy_mouthy":
                    detailsStringModel.jumpyMouthy = "Jumpy/Mouthy"
                default:
                    return
                    
                }
            }
        }
    }
    
    public func deleteNote(collectionId: String, documentId: String){
        Task {
            do {
//                let response = try await appwrite.databases.deleteDocument(
//                    databaseId: self.databaseId,
//                    collectionId: collectionId,
//                    documentId: documentId
//                )
                let response = try await appwrite.deleteDocument(collectionId, documentId)
                await MainActor.run {
                    //do stuff here:
                    noteWillDelete = true
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
