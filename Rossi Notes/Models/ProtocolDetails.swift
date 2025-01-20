//
//  Protocol.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/5/24.
//

import Foundation

////    func formatDate(from dateString: String) -> String {
////        let isoDateFormatter = ISO8601DateFormatter()
////        isoDateFormatter.formatOptions = .withFullDate
////        let formatedDate = isoDateFormatter.date(from: dateString) ?? Date.now
////        
////        //Non-ISO Date formatting, which is what is needed?
////        let dateFormatter = DateFormatter()
////        dateFormatter.dateStyle = .medium
////        
////        return dateFormatter.string(from: formatedDate)
////    }

@Observable class DetailsModel: Identifiable, ObservableObject {
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
    var creatorName: String = ""
}



