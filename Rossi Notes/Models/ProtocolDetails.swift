//
//  Protocol.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/5/24.
//

import Foundation

@Observable class DetailsModel: Identifiable, Codable {
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
    var creatorName: String = ""

    
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
