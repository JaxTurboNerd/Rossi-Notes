//
//  Document.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 1/10/25.
//

import Foundation

struct Protocol: Codable {
    var name: String
    var protocol_date: Date
    var dog_reactive: Bool
    var cat_reactive: Bool
    var barrier_reactive: Bool
    var leash_reactive: Bool
    var jumpy_mouthy: Bool
    var resource_guarder: Bool
    var stranger_reactive: Bool
    var place_routine: Bool
    var door_routine: Bool
    var loose_leash: Bool
    var shy_fearful: Bool
    var misc_notes: String
    var created_by: String
    //var updated_by: String
}
