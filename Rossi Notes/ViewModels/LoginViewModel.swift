//
//  LoginViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 12/5/24.
//

import Foundation
import Appwrite
import JSONCodable
import SwiftUI

@MainActor
final class LoginViewModel: ObservableObject {
    private let appwrite: Appwrite
    //@Binding var rememberMeIsOn: Bool
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isSubmitting = false
    @Published var rememberMe = false
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    @MainActor
    public func signIn() async throws {
        if rememberMe {
            print("remember me is on")//works
            //need to set to user defaults and check if there is a set value from a previous log on
        }
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
    
    func setRememberMe(_ email: String){
        //Save the user's login email to the User Defaults:
        UserDefaults.standard.set(email, forKey: "userEmail")
        print("remember me set to User Defaults")
    }
}
