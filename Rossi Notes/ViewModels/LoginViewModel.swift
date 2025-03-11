//
//  LoginViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/5/24.
//

import Foundation
import Appwrite
import JSONCodable
import NIOCore

@MainActor
class LoginViewModel: ObservableObject {
    private let appwrite: Appwrite
    
    @Published var email: String = "gboyd69@yahoo.com"
    @Published var password: String = "11Gunner$"
    @Published var response: String = ""
    @Published var errorMessage: String?
    @Published var isSubmitting = false
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
        
    @MainActor
    public func signIn(){
        self.isSubmitting = true
        self.errorMessage = nil
        
        Task {
            do {
                let session = try await appwrite.signIn(email, password)
                self.persistSession(session)
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
    
    private func persistSession(_ session: Session){
        // Save session details to UserDefaults or Keychain for persistence
        UserDefaults.standard.set(session.userId, forKey: "userId")
        UserDefaults.standard.set(session.secret, forKey: "sessionSecret")
    }
    
    //    public func getInitials() async throws -> ByteBuffer {
    //        //returns a ByteBuffer Object
    //        let bytes = try await appwrite.avatars.getInitials(width: 40)
    //        return bytes
    //    }
    
    enum LoginTextfieldError: Error {
        case emptyEmail, emptyPassword
    }
    
    private func checkLoginFields(_ email: String, _ password: String) throws -> Bool {
        if email.isEmpty {
            throw LoginTextfieldError.emptyEmail
        } else if password.isEmpty {
            throw LoginTextfieldError.emptyPassword
        }
        return true
    }
    
}
