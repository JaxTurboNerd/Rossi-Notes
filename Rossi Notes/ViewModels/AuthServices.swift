//
//  AuthServices.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 2/9/25.
//

import Foundation
import Appwrite
import JSONCodable

class AuthServices: ObservableObject {
    private let account: Account
    @Published var currentUser: User<[String: AnyCodable]>?
    @Published var isAuthenticated = false
    
    init(client: Client) {
        self.account = Account(client)
        checkAuthStatus()
    }
    
    func checkAuthStatus() {
        Task {
            do {
                currentUser = try await account.get()
                await MainActor.run {
                    self.isAuthenticated = true
                }
            } catch {
                await MainActor.run {
                    self.isAuthenticated = false
                    self.currentUser = nil
                }
            }
        }
    }
    
    func signIn(email: String, password: String) async throws -> User<[String: AnyCodable]> {
        do {
            let session = try await account.createEmailPasswordSession(
                email: email,
                password: password
            )
            let user = try await account.get()
            await MainActor.run {
                self.currentUser = user
                self.isAuthenticated = true
            }
            return user
        } catch {
            throw AuthError.signInFailed(error.localizedDescription)
        }
    }
    
    func signOut() async throws {
        do {
            try await account.deleteSession(sessionId: "current")
            await MainActor.run {
                self.currentUser = nil
                self.isAuthenticated = false
            }
        } catch {
            throw AuthError.signOutFailed(error.localizedDescription)
        }
    }
}

// Core/Models/AuthError.swift
enum AuthError: LocalizedError {
    case signInFailed(String)
    case signOutFailed(String)
    
    var errorDescription: String? {
        switch self {
        case .signInFailed(let message):
            return "Sign in failed: \(message)"
        case .signOutFailed(let message):
            return "Sign out failed: \(message)"
        }
    }
}
