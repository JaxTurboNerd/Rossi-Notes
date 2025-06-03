//
//  LoginViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/5/24.
//

import Foundation
import Appwrite
import JSONCodable

@MainActor
class LoginViewModel: ObservableObject {
    private let appwrite: Appwrite
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isSubmitting = false
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    @MainActor
    public func signIn() async throws {
        self.isSubmitting = true        
        do {
            let session = try await appwrite.signIn(email, password)
            self.persistSession(session)
            self.isSubmitting = false
        } catch {
            throw error
        }
    }
    
    private func persistSession(_ session: Session){
        // Save session details to UserDefaults or Keychain for persistence
        UserDefaults.standard.set(session.userId, forKey: "userId")
        UserDefaults.standard.set(session.secret, forKey: "sessionSecret")
    }
    
    private func setRememberMe(_ email: String){
        //Save the user's login email to the User Defaults:
        UserDefaults.standard.set(email, forKey: "userEmail")
    }
}
