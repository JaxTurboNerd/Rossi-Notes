//
//  SignUpViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/7/24.
//

import Foundation

class SignUpViewModel: ObservableObject {
    private let appwrite: Appwrite
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var passwordConfirm = ""
    
    @Published var errorMessage: String?
    @Published var isSubmitting = false
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    @MainActor
    public func signUp(){
        self.isSubmitting = true
        self.errorMessage = nil
        
        Task {
            do {
                let newUser = try await appwrite.createAccount(firstName, lastName, email, password)
            } catch {
                errorMessage = error.localizedDescription
                print(error.localizedDescription)
            }
        }
    }
}
