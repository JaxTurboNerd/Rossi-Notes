//
//  Protocol.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/5/24.
//

import Foundation

struct ProtocolDetails: Codable, Identifiable {
    let id: String
    let name: String
    let dogReactive: Bool
    let barrierReactive: Bool
    let miscNotes: String
    let protocolDate: Date
    let catReactive: Bool
    let resourceGuarder: Bool
    let strangerReactive: Bool
    let jumpyMouthy: Bool
    let doorRoutine: Bool
    let placeRoutine: Bool
    let leashReactive: Bool
    let creatorName: String
}
