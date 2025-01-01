//
//  Protocol.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/5/24.
//

import Foundation

@Observable class DetailsModel: Identifiable {
    var id = ""
    var name = ""
    var dogReactive = ""
    var barrierReactive = ""
    var miscNotes = ""
    var protocolDate = ""
    var catReactive = ""
    var resourceGuarder = ""
    var strangerReactive = ""
    var jumpyMouthy = ""
    var doorRoutine = ""
    var placeRoutine = ""
    var leashReactive = ""
    var creatorName = ""
    
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
