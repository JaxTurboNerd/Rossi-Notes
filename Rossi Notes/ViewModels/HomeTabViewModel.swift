//
//  HomeTabViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 3/24/25.
//

import Foundation
import Appwrite

@MainActor
class HomeTabViewModel: ObservableObject {
    let appwrite: Appwrite
    
    @Published var isSubmitting = false
    @Published var errorMessage = ""
    
    init(appwrite: Appwrite) {
        self.appwrite = appwrite
    }
    
    @MainActor
    public func signOut() async throws {
        self.isSubmitting = true
        
        do {
            try await appwrite.onLogout()
            //delete session from user defaults:
            deleteSession()
            self.isSubmitting = false
        } catch {
            throw AuthError.signOutFailed
        }
    }
    
    private func deleteSession(){
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "sessionSecret")
    }
}
