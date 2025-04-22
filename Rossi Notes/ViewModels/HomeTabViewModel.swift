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
    
    @MainActor
    public func fetchUserInitials(name: String) async throws {
        do {
            guard let data = try await appwrite.getInitials(name: name) else { return }
            let byteData = Data(buffer: data)
            if let uiImage = UIImage(data: byteData) {
                self.initialsImage = uiImage
            }
            //return initialsImage!
        } catch {
            print("Failed to fetch user's initials: \(error.localizedDescription)")
            //return nil
        }
    }
    
    @MainActor
    public func getAccount() async throws -> User<[String: AnyCodable]>? {
        do {
            let user = try await appwrite.getAccount()
            self.user = user
            return user
        } catch {
            print("get account failed: \(error.localizedDescription)")
            return nil
        }
    }
}
