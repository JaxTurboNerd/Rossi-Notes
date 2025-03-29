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
    private let appwrite: Appwrite
    
    @Published var isSubmitting = false
    @Published var errorMessage = ""
    
    init(appwrite: Appwrite) {
        self.appwrite = appwrite
    }
    
    @MainActor
    public func signOut(){
        self.isSubmitting = true
        
        Task {
            do {
                try await appwrite.onLogout()
                //delete session from user defaults:
                deleteSession()
                self.isSubmitting = false
            } catch {
                print(error.localizedDescription)
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    private func deleteSession(){
        UserDefaults.standard.removeObject(forKey: "userId")
        UserDefaults.standard.removeObject(forKey: "sessionSecret")
    }
}
