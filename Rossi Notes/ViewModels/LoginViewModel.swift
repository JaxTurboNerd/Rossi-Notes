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
    //let appwrite = Appwrite()
    
    @Published var email: String = "gboyd69@yahoo.com"
    @Published var password: String = "11Gunner$"
    @Published var response: String = ""
    @Published var errorMessage: String?
    @Published var isLoading = false
    @State var showAlert = false
    private let authServices: AuthServices
    
    init(authServices: AuthServices){
        self.authServices = authServices
    }
    
//    public func getAccount() async throws -> User<[String: AnyCodable]>{
//        return try await appwrite.account.get()
//        //or use?: appwrite.getAccount()
//    }
    
//    public func signIn(_ email: String,_ password: String){
//        self.isSubmitting = true
//        self.errorMessage = nil
//        Task {
//            do {
//                let session = try await appwrite.account.createEmailPasswordSession(
//                    email: email,
//                    password: password
//                )
//                persistSession(session)
//                await MainActor.run {
//                    self.appwrite.isLoggedIn = true
//                }
//            } catch {
//                await MainActor.run {
//                    self.errorMessage = error.localizedDescription
//                    print("Create document error \(String(describing: errorMessage))")
//                    self.appwrite.isLoggedIn = false
//                    self.isSubmitting = false
//                }
//            }
//        }
//    }
    
    private func persistSession(_ session: Session){
        // Save session details to UserDefaults or Keychain for persistence
        UserDefaults.standard.set(session.userId, forKey: "userId")
        UserDefaults.standard.set(session.secret, forKey: "sessionSecret")
    }
    
//    private func checkSession(){
//        guard let userId = UserDefaults.standard.string(forKey: "userId"),
//              let sessionSecret = UserDefaults.standard.string(forKey: "sessionSecret") else {return}
//        Task {
//            do {
//                let session = try await appwrite.getAccount()
//                await MainActor.run {
//                    self.appwrite.isLoggedIn = true
//                }
//
//            } catch {
//                self.errorMessage = error.localizedDescription
//                self.appwrite.isLoggedIn = false
//                //clear session?
//            }
//        }
//    }
    
//    public func getInitials() async throws -> ByteBuffer {
//        //returns a ByteBuffer Object
//        let bytes = try await appwrite.avatars.getInitials(width: 40)
//        return bytes
//    }
    
    @MainActor
    func signIn() async {
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await authServices.signIn(email: email, password: password)
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
    }
    
    @MainActor
    func signOut() async {
        do {
            try await authServices.signOut()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
