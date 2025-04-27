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
    
    public func fetchDocument(collectionId: String ,documentId: String) async throws {
        isLoading = true
        errorMessage = nil
        
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
            self.errorMessage = error.localizedDescription
            self.isLoading = false
            
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
        isoDateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let formattedDate = isoDateFormatter.date(from: dateString) ?? Date.now
        
        return formattedDate
    }
    
    private func setDetailsModel(response: Document<[String: AnyCodable]>){
        //formats the response date value (string) to a Date object:
        
        guard let protocol_date = response.data["protocol_date"]?.value as? String else {
            print("protocol_date not found")
            return
        }
        
        let protocolDateObject = formatDateString(from: protocol_date)
        //set the detailsModel instance values;
        
        guard let id = response.data["$id"]?.value as? String else {
            print("id not found")
            return
        }
        guard let name = response.data["name"]?.value as? String else {
            print("name not found")
            return
        }
        guard let jumpyMouthy = response.data["jumpy_mouthy"]?.value as? Bool else {
            print("jumpyMouthy not found")
            return
        }
        guard let dogReactive = response.data["dog_reactive"]?.value as? Bool else {
            print("dogReactive not found")
            return
        }
        guard let catReactive = response.data["cat_reactive"]?.value as? Bool else {
            print("catReactive not found")
            return
        }
        guard let leashReactive = response.data["leash_reactive"]?.value as? Bool else {
            print("leashReactive not found")
            return
        }
        guard let barrierReactive = response.data["barrier_reactive"]?.value as? Bool else {
            print("barrierReactive not found")
            return
        }
        guard let doorRoutine = response.data["door_routine"]?.value as? Bool else {
            print("doorRoutine not found")
            return
        }
        guard let placeRoutine = response.data["place_routine"]?.value as? Bool else {
            print("placeRoutine not found")
            return
        }
        guard let resourceGuarder = response.data["resource_guarder"]?.value as? Bool else {
            print("resourceGuarder not found")
            return
        }
        guard let strangerReactive = response.data["stranger_reactive"]?.value as? Bool else {
            print("strangerReactive not found")
            return
        }
        guard let shyFearful = response.data["shy_fearful"]?.value as? Bool else {
            print("shyFearful not found")
            return
        }
        guard let miscNotes = response.data["misc_notes"]?.value as? String else {
            print("miscNotes not found")
            return
        }
        
        detailsModel?.id = id
        detailsModel?.name = name
        detailsModel?.protocolDate = protocolDateObject
        detailsModel?.jumpyMouthy = jumpyMouthy
        detailsModel?.dogReactive = dogReactive
        detailsModel?.catReactive = catReactive
        detailsModel?.leashReactive = leashReactive
        detailsModel?.barrierReactive = barrierReactive
        detailsModel?.doorRoutine = doorRoutine
        detailsModel?.placeRoutine = placeRoutine
        detailsModel?.resourceGuarder = resourceGuarder
        detailsModel?.strangerReactive = strangerReactive
        detailsModel?.shyFearful = shyFearful
        detailsModel?.miscNotes = miscNotes
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
                    detailsStringModel.strangerReactive = "Avoid Strangers"
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
                case "shy_fearful":
                    detailsStringModel.shyFearful = "Shy / Fearful"
                default:
                    return
                    
                }
            }
        }
    }
    
    public func deleteNote(collectionId: String, documentId: String) async throws {
        do {
            let _ = try await appwrite.deleteDocument(collectionId, documentId)
            noteWillDelete = true
        } catch {
            print("delete document error \(String(describing: errorMessage))")
            self.errorMessage = error.localizedDescription
            self.isLoading = false
        }
    }
}
