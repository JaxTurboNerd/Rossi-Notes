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
    
    func checkSignUpFields(
        _ fname: String,
        _ lname: String,
        _ email: String,
        _ password: String,
        _ password2: String
    ) throws -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        if fname.isEmpty {
            throw SignUpTextfieldError.emptyFname
        } else if lname.isEmpty {
            throw SignUpTextfieldError.emptyLname
        } else if email.isEmpty {
            throw SignUpTextfieldError.emptyEmail
        } else if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
            throw SignUpTextfieldError.invalidEmail
        } else if password.isEmpty {
            throw SignUpTextfieldError.emptyPassword
        } else if password2.isEmpty {
            throw SignUpTextfieldError.emptyPassword2
        } else if password != password2 {
            throw SignUpTextfieldError.pwordsNotMatched
        } else if password.count < 9 || password2.count < 9 {
            throw SignUpTextfieldError.invalidPassword
        }
        return true
    }
}

//Used to validate the user required textfields on the front end.  Checks for empty fields and password
//mis-matches, and invalid emails.
enum SignUpTextfieldError: Error, LocalizedError {
    case emptyFname, emptyLname, emptyEmail, emptyPassword, emptyPassword2, pwordsNotMatched, invalidEmail, invalidPassword
    
    var alertMessage: String {
        switch self {
        case .emptyFname:
            return "First name is required."
        case .emptyLname:
            return "Last name is required."
        case .emptyEmail:
            return "Email is required."
        case .emptyPassword:
            return "Password is required."
        case .emptyPassword2:
            return "Confirmation password is required"
        case .pwordsNotMatched:
            return "Passwords do not match."
        case .invalidEmail:
            return "Invalid email format."
        case .invalidPassword:
            return "Password must be at least 9 characters long."
        }
        
    }
}
