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
    var protocolDate = Date()
    var catReactive = ""
    var resourceGuarder = ""
    var strangerReactive = ""
    var jumpyMouthy = ""
    var doorRoutine = ""
    var placeRoutine = ""
    var leashReactive = ""
    var creatorName = ""
    
    func formatDate(from dateString: String) -> Date? {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [
            .withMonth,
            .withDay,
            .withYear
        ]
        
//        dateFormatter.dateStyle = .medium
//        dateFormatter.timeStyle = .none
        let formatedDate = dateFormatter.date(from: dateString)//returns nil and not a formatted date
        print("formated Date: \(formatedDate ?? .now)") //prints now and not the parameter date
        return formatedDate
    }
}
