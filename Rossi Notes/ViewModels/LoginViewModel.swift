//
//  LoginViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/5/24.
//

import Foundation

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var response: String = ""
}
