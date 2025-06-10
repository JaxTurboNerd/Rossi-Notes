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
    @Published var document: Document<[String: AnyCodable]>?
    @Published var initialsImage: UIImage? = nil
    @Published var creatorImage: UIImage? = nil
    @Published var initialsImageData: Data? = nil
    @Published var formattedStringDate = ""
    @Published var failedToFetch: Bool = false
    @Published var isSubmitting: Bool = false
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
                throw FetchDocumentsError.failedFetch
            }
            self.document = document
            self.isLoading = false
            setDetailsModel(response: document)
            formattedStringDate = formatDate(from: detailsModel?.protocolDate ?? Date.now)
            setDetailsStringModel(responseData: document.data)
        } catch {
            self.isLoading = false
            throw FetchDocumentsError.failedFetch
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
            throw ArchiveProtocolError.failedToDelete
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
        } catch DetailViewError.failedToFetchInitials {
            print("Failed to fetch initials")
        } catch {
            print("Error fetching initials \(error.localizedDescription)")
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
        }
    }
    
    public func archiveProtocol(originalCollectionID: String, originalDocumentID: String, noteDetails: DetailsModel) async throws {
        //Determine which collection API key to use:
        var collectionId: String {
            do {
                let IdKey: String = try Configuration.value(for: "ARCHIVE_COLL_ID")
                return IdKey
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
                throw ArchiveProtocolError.failedToArchive
            }
            //Need to pass in the ARCHIVE collection id to the createDocument func:
            let _ = try await appwrite.createDocument(collectionId, ID.unique(), dataString)
            self.isSubmitting = false
            
        } catch JSONError.invalidData {
            self.isSubmitting = false
            
        } catch JSONError.typeMismatch {
            self.isSubmitting = false
            
        } catch ArchiveProtocolError.failedToArchive {
            self.isSubmitting = false
        } catch {
            self.isSubmitting = false
            throw ArchiveProtocolError.failedToArchive
        }
        
        //Deleted the "Old" document:
        do {
            try await appwrite.deleteDocument(originalCollectionID, originalDocumentID)
        } catch {
            print("Error deleting old document")
            throw UpdateProtocolError.failedToChangeProtocolLevel
        }
    }
    
}

enum DetailViewError: LocalizedError {
    case failedToFetchDocument
    case failedToFetchUser
    case failedToFetchCreator
    case failedToFetchInitials
    
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
        }
    }
}

enum ArchiveProtocolError: LocalizedError {
    case failedToArchive, failedToDelete
    
    var errorDescription: String? {
        switch self {
        case .failedToArchive:
            return "Failed to archive.  Please try again."
        case .failedToDelete:
            return "Failed to delete.  Please try again."
        }
    }
}

