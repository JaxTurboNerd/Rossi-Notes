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
    //@Published var errorMessage: String = ""
    @Published var document: Document<[String: AnyCodable]>?
    @Published var initialsImage: UIImage? = nil
    @Published var creatorImage: UIImage? = nil
    @Published var initialsImageData: Data? = nil
    @Published var formattedStringDate = ""
    @Published var failedToFetch: Bool = false
    //This model used to display string values from the details model:
    @ObservedObject var detailsStringModel = DetailsStringModel()
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
        do {
            guard let document = try await appwrite.listDocument(collectionId, documentId) else {
                self.failedToFetch = true
                throw AppwriteDocumentError.failedToFetch
                //throw FetchDocumentsError.failedFetch
            }
            self.document = document
            self.isLoading = false
            setDetailsModel(response: document)
            formattedStringDate = formatDate(from: detailsModel?.protocolDate ?? Date.now)
            setDetailsStringModel(responseData: document.data)
        } catch {
            self.isLoading = false
            throw AppwriteDocumentError.failedToFetch
        }
        
        do {
            try await fetchCreatorInfo()
        } catch {
            self.isLoading = false
            throw DetailViewError.failedToFetchCreator
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
        
        if let protocolDate = response.data["protocol_date"]?.value as? String {
            //print("protocol_date not found")
            let protocolDateObject = formatDateString(from: protocolDate)
            detailsModel?.protocolDate = protocolDateObject
        }
        
        //set the detailsModel instance values;
        if let id = response.data["$id"]?.value as? String {
            detailsModel?.id = id
        }
        if let name = response.data["name"]?.value as? String {
            detailsModel?.name = name
        }
        if let jumpyMouthy = response.data["jumpy_mouthy"]?.value as? Bool {
            detailsModel?.jumpyMouthy = jumpyMouthy
        }
        if let dogReactive = response.data["dog_reactive"]?.value as? Bool {
            detailsModel?.dogReactive = dogReactive
        }
        if let catReactive = response.data["cat_reactive"]?.value as? Bool {
            detailsModel?.catReactive = catReactive
        }
        if let leashReactive = response.data["leash_reactive"]?.value as? Bool {
            detailsModel?.leashReactive = leashReactive
        }
        if let barrierReactive = response.data["barrier_reactive"]?.value as? Bool {
            detailsModel?.barrierReactive = barrierReactive
        }
        if let doorRoutine = response.data["door_routine"]?.value as? Bool {
            detailsModel?.doorRoutine = doorRoutine
        }
        if let placeRoutine = response.data["place_routine"]?.value as? Bool {
            detailsModel?.placeRoutine = placeRoutine
        }
        if let resourceGuarder = response.data["resource_guarder"]?.value as? Bool {
            detailsModel?.resourceGuarder = resourceGuarder
        }
        if let strangerReactive = response.data["stranger_reactive"]?.value as? Bool {
            detailsModel?.strangerReactive = strangerReactive
        }
        if let shyFearful = response.data["shy_fearful"]?.value as? Bool {
            detailsModel?.shyFearful = shyFearful
        }
        if let looseLeash = response.data["loose_leash"]?.value as? Bool {
            detailsModel?.looseLeash = looseLeash
        }
        if let dragline = response.data["dragline"]?.value as? Bool {
            detailsModel?.dragline = dragline
        }
        if let chainLeash = response.data["chain_leash"]?.value as? Bool {
            detailsModel?.chainLeash = chainLeash
        }
        if let harness = response.data["harness"]?.value as? Bool {
            detailsModel?.harness = harness
        }
        if let gentleLeader = response.data["gentle_leader"]?.value as? Bool {
            detailsModel?.gentleLeader = gentleLeader
        }
        if let miscNotes = response.data["misc_notes"]?.value as? String {
            detailsModel?.miscNotes = miscNotes
        }
        if let createdBy = response.data["created_by"]?.value as? String {
            detailsModel?.createdBy = createdBy
        } else {
            detailsModel?.createdBy = ""
        }
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
                    detailsStringModel.shyFearful = "Shy / Fearful\n Avoid Petting!"
                case "loose_leash":
                    detailsStringModel.looseLeash = "Practice Loose Leash Walking"
                case "dragline":
                    detailsStringModel.dragline = "Dragline"
                case "chain_leash":
                    detailsStringModel.chainLeash = "Use Chain Leash"
                case "harness":
                    detailsStringModel.harness = "Harness"
                case "gentle_leader":
                    detailsStringModel.gentleLeader = "Gentle Leader"
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
            print("delete document error \(error.localizedDescription)")
            self.isLoading = false
            throw DetailViewError.failedToDeleteDocument
        }
    }
    
    private func fetchUserInfo() async throws {
        do {
            guard let userName = appwrite.currentUser?.name else {
                throw DetailViewError.failedToFetchUser
            }
            guard let data = try await appwrite.getInitials(name: userName) else {
                throw DetailViewError.failedToFetchInitials
            }
            let byteData = Data(buffer: data)
            self.initialsImageData = byteData
            if let uiImage = UIImage(data: byteData) {
                self.initialsImage = uiImage
            }
        } catch DetailViewError.failedToFetchUser {
            print("failed to fetch user")
            throw DetailViewError.failedToFetchUser
        } catch DetailViewError.failedToFetchInitials {
            print("Failed to fetch initials")
            throw DetailViewError.failedToFetchInitials
        } catch {
            print("Error fetching initials \(error.localizedDescription)")
            throw DetailViewError.failedToFetchUser
        }
    }
    
    public func fetchCreatorInfo() async throws {
        do {
            //let creatorName = detailsModel?.createdBy
            guard let creatorName = detailsModel?.createdBy else {
                throw DetailViewError.failedToFetchCreator
            }
            guard let data = try await appwrite.getInitials(name: creatorName) else {
                throw DetailViewError.failedToFetchInitials
            }
            let byteData = Data(buffer: data)
            //self.creatorImageData = byteData  //probably don't need
            
            if let uiImage = UIImage(data: byteData) {
                self.creatorImage = uiImage
            }
        } catch DetailViewError.failedToFetchCreator {
            throw DetailViewError.failedToFetchCreator
        } catch DetailViewError.failedToFetchInitials {
            throw DetailViewError.failedToFetchInitials
        } catch {
            print("error fetching creator initials \(error.localizedDescription)")
            throw DetailViewError.failedToFetchCreator
        }
    }
}

enum DetailViewError: LocalizedError {
    case failedToFetchDocument
    case failedToFetchUser
    case failedToFetchCreator
    case failedToFetchInitials
    case failedToDeleteDocument
    
    var errorDescription: String? {
        switch self {
        case .failedToFetchDocument:
            return "Failed to fetch document."
        case .failedToFetchUser:
            return "Failed to fetch user."
        case .failedToFetchCreator:
            return "Failed to fetch creator."
        case .failedToFetchInitials:
            return "Failed to fetch initials."
        case .failedToDeleteDocument:
            return "Failed to delete document."
        }
    }
}
