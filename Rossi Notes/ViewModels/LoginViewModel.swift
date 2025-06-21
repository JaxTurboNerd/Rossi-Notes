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
    
    @Published var email: String = UserDefaults.standard.string(forKey: "userEmail") ?? ""
    @Published var password: String = UserDefaults.standard.string(forKey: "password") ?? ""
    @Published var isSubmitting = false
    @Published var rememberMeSelected = UserDefaults.standard.bool(forKey: "rememberMeSelected")
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    @MainActor
    public func signIn() async throws {
        if rememberMeSelected {
            //need to set to user defaults and check if there is a set value from a previous log on:
            setRememberMe(rememberMeSelected: rememberMeSelected, email: email, password: password)
        } else {
            setRememberMe(rememberMeSelected: false, email: "", password: "")
        }
        self.isSubmitting = true
        do {
            let session = try await appwrite.signIn(email, password)
            self.persistSession(session)
            self.isSubmitting = false
        } catch {
            //below will throw the custom AuthError
            throw error
        }
    }
    
    private func persistSession(_ session: Session){
        // Save session details to UserDefaults or Keychain for persistence
        UserDefaults.standard.set(session.userId, forKey: "userId")
        UserDefaults.standard.set(session.secret, forKey: "sessionSecret")
    }
    
    func setRememberMe(rememberMeSelected: Bool, email: String, password: String) {
        //Save the user's login email and password to the User Defaults:
        UserDefaults.standard.set(rememberMeSelected, forKey: "rememberMeSelected")
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(password, forKey: "password")
    }
}
