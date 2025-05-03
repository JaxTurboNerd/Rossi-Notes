//
//  SignUpViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/7/24.
//

import Foundation
import Appwrite
import JSONCodable

@MainActor
class SignUpViewModel: ObservableObject {
    private let appwrite: Appwrite
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var passwordConfirm = ""
    @Published var errorMessage = ""
    @Published var isSubmitting = false
    //@Published var newUser: User<[String: AnyCodable]>? //don't know if I will need this later
    @Published var isSignedUp: Bool = false
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    @MainActor
    public func signUp() async throws {
        self.isSubmitting = true
        do {
            let response = try await appwrite.createAccount(firstName, lastName, email, password)
            self.isSignedUp = true
        } catch {
            self.errorMessage = error.localizedDescription
            throw UserError.failed(error.localizedDescription)
        }
    }
}
