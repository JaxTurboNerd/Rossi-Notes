//
//  LoginViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/5/24.
//

import Foundation
import Appwrite

class LoginViewModel: ObservableObject {
    @Published var email: String = "gboyd69@yahoo.com"
    @Published var password: String = "11Gunner$"
    @Published var response: String = ""
    @Published var session: Session?
}
