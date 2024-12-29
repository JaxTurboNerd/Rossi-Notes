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
    @Published var protocolDetails: [ProtocolDetails] = []
    @Published var isLoading = false
}
