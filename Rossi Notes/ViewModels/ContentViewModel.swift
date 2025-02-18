//
//  ContentViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 2/12/25.
//

import Foundation

class ContentViewModel: ObservableObject {
    private let authServices: AuthServices
    
    init(authServices: AuthServices) {
        self.authServices = authServices
    }
}
