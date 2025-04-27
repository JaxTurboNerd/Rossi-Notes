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
    @Published var errorMessage: String = ""
    @Published var document: Document<[String: AnyCodable]>?
    @Published var initialsImage: UIImage? = nil
    @Published var creatorImage: UIImage? = nil
    @Published var initialsImageData: Data? = nil
    @Published var creatorImageData: Data? = nil
    //This model used to display string values from the details model:
    @ObservedObject var detailsStringModel = DetailsStringModel()
    @Published var formattedStringDate = ""
    @State var noteWillDelete = false
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
        //call function to get/set user's initials:
        Task {
            //try await fetchUserInfo()
            try await fetchCreatorInfo()
        }
    }
    
    //This function is intended to inject an instance of the DetailsModel:
    public func modelSetup(_ model: DetailsModel){
        self.detailsModel = model
    }
    
    public func fetchDocument(collectionId: String ,documentId: String) async throws {
        isLoading = true
        do {
            guard let document = try await appwrite.listDocument(collectionId, documentId) else {
                throw DetailViewError.failedToFetchDocument
            }
            self.document = document
            self.isLoading = false
            setDetailsModel(response: document)
            formattedStringDate = formatDate(from: detailsModel?.protocolDate ?? Date.now)
            setDetailsStringModel(responseData: document.data)
        } catch DetailViewError.failedToFetchDocument {
            self.isLoading = false
            self.errorMessage = "Failed to fetch document."
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
        let protocolDateObject = formatDateString(from: response.data["protocol_date"]?.value as! String)
        //set the detailsModel instance values;
        detailsModel?.id = response.data["$id"]?.value as! String
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
        detailsModel?.shyFearful = response.data["shy_fearful"]?.value as! Bool
        detailsModel?.miscNotes = response.data["misc_notes"]?.value as! String
        
        guard let createdBy = response.data["created_by"]?.value as? String else {
            print("failed to fetch createdBy info")
            return
        }
        detailsModel?.createdBy = createdBy
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
            self.errorMessage = "Failed to fetch user."
        } catch DetailViewError.failedToFetchInitials {
            print("Failed to fetch initials")
            self.errorMessage = "Failed to fetch initials."
        } catch {
            print("Error fetching initials \(error.localizedDescription)")
        }
    }
    
    public func fetchCreatorInfo() async throws {
        do {
            guard let creatorName = detailsModel?.createdBy else {
                throw DetailViewError.failedToFetchCreator
            }
            guard let data = try await appwrite.getInitials(name: creatorName) else {
                throw DetailViewError.failedToFetchInitials
            }
            let byteData = Data(buffer: data)
            self.creatorImageData = byteData
            
            if let uiImage = UIImage(data: byteData) {
                self.creatorImage = uiImage
            }
        } catch DetailViewError.failedToFetchCreator {
            self.errorMessage = "Failed to fetch creator."
        } catch DetailViewError.failedToFetchInitials {
            self.errorMessage = "Failed to fetch initials."
        } catch {
            print("error fetching creator initials \(error.localizedDescription)")
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
