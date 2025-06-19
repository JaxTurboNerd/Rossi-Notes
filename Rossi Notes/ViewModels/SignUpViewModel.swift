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
    @Published var isSubmitting = false
    @Published var successfulSignedUp: Bool = false
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    @MainActor
    public func signUp() async throws {
        self.isSubmitting = true
        do {
            _ = try await appwrite.createAccount(firstName, lastName, email, password)
            self.successfulSignedUp = true
        } catch {
            throw UserAccountError.failed(error.localizedDescription)
        }
    }
}
