//
//  Protocol.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/5/24.
//

import Foundation

class DetailsModel: Identifiable, ObservableObject {
    var id: String = ""
    var name: String = ""
    var dogReactive: Bool = false
    var barrierReactive: Bool = false
    var miscNotes: String = ""
    var protocolDate: Date = Date.now
    var catReactive: Bool = false
    var resourceGuarder: Bool = false
    var strangerReactive: Bool = false
    var jumpyMouthy: Bool = false
    var doorRoutine: Bool = false
    var placeRoutine: Bool = false
    var leashReactive: Bool = false
    var looseLeash: Bool = false
    var shyFearful: Bool = false
    var dragline: Bool = false
    var harness: Bool = false
    var chainLeash: Bool = false
    var gentleLeader: Bool = false
    var createdBy: String = ""
    //var updatedBy: String = ""
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
    var looseLeash: String = ""
    var shyFearful: String = ""
    var createdBy: String = ""
    var dragline: String = ""
    var harness: String = ""
    var chainLeash: String = ""
    var gentleLeader: String = ""
    //var updatedBy: String = ""
    
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



