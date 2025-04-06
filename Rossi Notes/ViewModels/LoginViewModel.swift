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
    
    @Published var email: String = "gboyd69@yahoo.com"
    @Published var password: String = "11Gunner$"
    @Published var errorMessage: String?
    @Published var isSubmitting = false
    //@Published var session: Session?
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    @MainActor
    public func signIn() async throws {
        self.isSubmitting = true
        self.errorMessage = nil
        
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
}
