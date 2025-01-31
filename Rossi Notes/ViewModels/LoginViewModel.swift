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
import SwiftUI

class LoginViewModel: ObservableObject {
    let appwrite = Appwrite()
    
    @Published var email: String = "gboyd69@yahoo.com"
    @Published var password: String = "11Gunner$"
    @Published var response: String = ""
    //@Published var session: Session?
    @Published var user: User<[String: AnyCodable]>?
    @Published var errorMessage: String?
    @Published var isSubmitting = false
    @Published var isLoggedIn = false
    @State var showAlert = false
    
    public func getAccount() async throws -> User<[String: AnyCodable]>{
        return try await appwrite.account.get()
    }
    
    public func signIn(_ email: String,_ password: String){
        self.isSubmitting = true
        self.errorMessage = nil
        Task {
            do {
                let session = try await appwrite.account.createEmailPasswordSession(
                    email: email,
                    password: password
                )
                self.persistSession(session)
                await MainActor.run {
                    self.isLoggedIn = true
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    print("Create document error \(String(describing: errorMessage))")
                    self.isSubmitting = false
                }
            }
        }
    }
    
    private func persistSession(_ session: Session){
        // Save session details to UserDefaults or Keychain for persistence
        UserDefaults.standard.set(session.userId, forKey: "userId")
        UserDefaults.standard.set(session.secret, forKey: "sessionSecret")
    }
    
    public func getInitials() async throws -> ByteBuffer {
        //returns a ByteBuffer Object
        let bytes = try await appwrite.avatars.getInitials(width: 40)
        return bytes
    }
}
