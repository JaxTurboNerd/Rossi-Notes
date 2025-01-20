//
//  Protocol.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/5/24.
//

import Foundation

//@Observable class DetailsModel: Identifiable, ObservableObject {
//    var id: String = ""
//    var name: String = ""
//    var dogReactive: String = ""
//    var barrierReactive: String = ""
//    var miscNotes: String = ""
//    var protocolDate: String = ""
//    var catReactive: String = ""
//    var resourceGuarder: String = ""
//    var strangerReactive: String = ""
//    var jumpyMouthy: String = ""
//    var doorRoutine: String = ""
//    var placeRoutine: String = ""
//    var leashReactive: String = ""
//    var creatorName: String = ""
//
//    
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
//}

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
    
    //possibly initialize the object with the instance document.data?
//    init(id: String, name: String, dogReactive: Bool, barrierReactive: Bool, miscNotes: String, protocolDate: Date, catReactive: Bool, resourceGuarder: Bool, strangerReactive: Bool, jumpyMouthy: Bool, doorRoutine: Bool, placeRoutine: Bool, leashReactive: Bool, creatorName: String) {
//        self.id = id
//        self.name = name
//        self.dogReactive = dogReactive
//        self.barrierReactive = barrierReactive
//        self.miscNotes = miscNotes
//        self.protocolDate = protocolDate
//        self.catReactive = catReactive
//        self.resourceGuarder = resourceGuarder
//        self.strangerReactive = strangerReactive
//        self.jumpyMouthy = jumpyMouthy
//        self.doorRoutine = doorRoutine
//        self.placeRoutine = placeRoutine
//        self.leashReactive = leashReactive
//        self.creatorName = creatorName
//    }
    //then create function to return string value types to be used by the view:
}



