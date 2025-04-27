//
//  HomeTabViewModel.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 3/24/25.
//

import SwiftUI
import Appwrite
import JSONCodable

class HomeTabViewModel: ObservableObject {
    private let appwrite: Appwrite
    
    @Published var isSubmitting = false
    @Published var errorMessage = ""
    @Published var initialsImage: UIImage? = nil
    @Published var user: User<[String: AnyCodable]>? = nil
    @Published var userName: String = ""
    
    init(appwrite: Appwrite) {
        self.appwrite = appwrite
        Task {
            await fetchUserName()
        }
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
    
    @MainActor public func fetchUserName() {
        self.userName = appwrite.currentUser?.name ?? ""
    }
}
