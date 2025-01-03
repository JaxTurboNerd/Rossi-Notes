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
    private let client: Client
    private let databases: Databases
    
    @Published var detailsData = DetailsModel()
    @Published var document: Document<[String: AnyCodable]>?
    @Published var isLoading = false
    @Published public var errorMessage: String?
    
    private let databaseId = "66a04cba001cb48a5bd7"
    public var collectionID = ""
    
    init() {
        // Initialize Appwrite client
        client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("66a04859001d3df0988d")
        
        databases = Databases(client)
    }
    
    public func fetchDocument(collectionId: String ,documentId: String){
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await databases.getDocument(
                    databaseId: self.databaseId,
                    collectionId: collectionId,
                    documentId: documentId,
                    queries: [] // optional
                )
                await MainActor.run {
                    self.document = response
                    self.isLoading = false
                    decodeResponse(response: document?.data ?? ["Error": AnyCodable("error")])
                }
                
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func decodeResponse(response: Dictionary<String, AnyCodable>){
        //assign response data values to the data model:
        detailsData.id = response["$id"]?.value as! String
        detailsData.name = response["name"]?.value as! String
        detailsData.miscNotes = response["misc_notes"]?.value as! String
        let date = response["protocol_date"]?.value as! String
        detailsData.protocolDate = detailsData.formatDate(from: date)
        
        for(key, value) in response {
            if (value == true){
                switch key {
                case "leash_reactive":
                    detailsData.leashReactive = "Leash Reactive"
                case "cat_reactive":
                    detailsData.catReactive = "Cat Reactive"
                case "resource_guarder":
                    detailsData.resourceGuarder = "Resource Guarder"
                case "stranger_reactive":
                    detailsData.strangerReactive = "Stranger Reactive"
                case "door_routine":
                    detailsData.doorRoutine = "Practice Door Routine"
                case "barrier_reactive":
                    detailsData.barrierReactive = "Barrier Reactive"
                case "dog_reactive":
                    detailsData.dogReactive = "Dog Reactive"
                case "place_routine":
                    detailsData.placeRoutine = "Practice Place Routine"
                case "jumpy_mouthy":
                    detailsData.jumpyMouthy = "Jumpy/Mouthy"
                default:
                    return
                    
                }
            }
        }
    }
    public func showTextViews() -> some View {
//        if(detailsData.barrierReactive != nil) {
//            print("barrier test")
//        }
//        if(detailsData.dogReactive.isEmpty) {
//            print("Not dog reactive test")
//        }
//        let mirror = Mirror(reflecting: detailsData)
//        for item in mirror.children {
//            if let propertyName = item.label {
//                //print("\(propertyName): \(item.value)")
//                print("mirror value type: \(type(of: item.value))")
//            }
//        }
        return Text("Test")
    }
}
