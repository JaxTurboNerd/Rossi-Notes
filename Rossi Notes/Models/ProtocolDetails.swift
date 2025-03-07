//
//  Protocol.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/5/24.
//

import Foundation

class DetailsModel: Identifiable, ObservableObject {
    @Published var id: String = ""
    @Published var name: String = ""
    @Published var dogReactive: Bool = false
    @Published var barrierReactive: Bool = false
    @Published var miscNotes: String = ""
    @Published var protocolDate: Date = Date.now
    @Published var catReactive: Bool = false
    @Published var resourceGuarder: Bool = false
    @Published var strangerReactive: Bool = false
    @Published var jumpyMouthy: Bool = false
    @Published var doorRoutine: Bool = false
    @Published var placeRoutine: Bool = false
    @Published var leashReactive: Bool = false
    @Published var creatorName: String = ""
}

class DetailsStringModel: Identifiable, ObservableObject {
    var id: String = ""
    var name: String = ""
    var dogReactive: String = ""
    var barrierReactive: String = ""
    var miscNotes: String = ""
    var protocolDate: String = ""
    var catReactive: String = ""
    var resourceGuarder: String = ""
    var strangerReactive: String = ""
    var jumpyMouthy: String = ""
    var doorRoutine: String = ""
    var placeRoutine: String = ""
    var leashReactive: String = ""
    //var creatorName: String = ""
    
    func formatDate(from dateString: String) -> String {
           let isoDateFormatter = ISO8601DateFormatter()
           isoDateFormatter.formatOptions = .withFullDate
           let formatedDate = isoDateFormatter.date(from: dateString) ?? Date.now
   
           //Non-ISO Date formatting, which is what is needed?
           let dateFormatter = DateFormatter()
           dateFormatter.dateStyle = .medium
   
           return dateFormatter.string(from: formatedDate)
       }
}



