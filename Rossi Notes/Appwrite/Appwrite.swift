//
//  Appwrite.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/30/24.
//

import Foundation
import SwiftUI
import Appwrite
import AppwriteEnums
import AppwriteModels
import JSONCodable
import NIOCore

@MainActor
class Appwrite: ObservableObject {
    //initialize appwrite:
    private let client: Client
    let account: Account
    private let avatars: Avatars
    private let databases: Databases
    private var databaseId: String {
        do {
            let config : String = try Configuration.value(for: "DATABASE_ID")
            return config
        } catch {
            print("database configuration error")
            return ""
        }
    }
    @Published var currentUser: User<[String: AnyCodable]>?
    @Published var initialsImage: UIImage? = nil
    @Published var isAuthenticated = false
    @Published var isLoading = false
    
    public init() {
        var projectId: String {
            do {
                let config : String = try Configuration.value(for: "PROJECT_ID")
                return config
            } catch {
                print("project configuration error")
                return ""
            }
        }

        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject(projectId)
        
        self.account = Account(client)
        self.avatars = Avatars(client)
        self.databases = Databases(client)
    }
    
    func checkAuthStatus() async {
        isLoading = true
        do {
            currentUser = try await getAccount()
            self.isAuthenticated = true
            self.isLoading = false
        } catch {
            print("auth error: \(error.localizedDescription)")
            self.isAuthenticated = false
            self.currentUser = nil
            self.isLoading = false
        }
    }
    
    //creates a new account
    public func createAccount(_ firstName: String, _ lastName: String, _ email: String,_ password: String) async throws -> User<[String: AnyCodable]> {
        do {
            let name = firstName + " " + lastName
            let newUser = try await account.create(userId: ID.unique(), email: email, password: password, name: name)
            return newUser
        } catch let error as AppwriteError {
            if error.message == "Invalid `email` param: Value must be a valid email address" {
                print("Appwrite file error: \(error.localizedDescription)")
                throw UserError.invalidEmail
            } else if error.message == "Invalid `password` param: Password must be between 8 and 265 characters long, and should not be one of the commonly used password." {
                throw UserError.invalidPassword
            } else if error.type == "user_password_mismatch" {
                throw UserError.passwordMismatch
            } else {
                print("Create account error: \(error.localizedDescription)")
                throw error
            }
        }
    }
    
    public func getAccount() async throws -> User<[String: AnyCodable]>?{
        do {
            let response = try await account.get()
            self.currentUser = response
            return currentUser
        } catch let error as AppwriteError {
            if error.type == "user_invalid_credentials" {
                throw AuthError.invalidCredentials
            } else if error.type == "user_blocked" {
                throw AuthError.userBlocked
            } else if error.type == "general_argument_invalid" {
                throw AuthError.generalArgumentError
            } else {
                print("Get account error: \(error.localizedDescription)")
                throw error
            }
        }
    }
    
    public func signIn(_ email: String, _ password: String) async throws -> Session {
        do {
            let session = try await account.createEmailPasswordSession(
                email: email,
                password: password
            )
            currentUser = try await getAccount() //should probably nest in another do catch
            self.isAuthenticated = true
            return session
        } catch let error as AppwriteError {
            if error.type == "user_invalid_credentials" {
                throw AuthError.invalidCredentials
            } else if error.type == "user_blocked" {
                throw AuthError.userBlocked
            } else if error.type == "general_argument_invalid" {
                throw AuthError.generalArgumentError
            } else {
                print("Sign in error: \(error.localizedDescription)")
                throw error
            }
        }
    }
    
    public func getInitials(name: String) async throws -> ByteBuffer? {
        do {
            //returns a ByteBuffer Object
             let data = try await avatars.getInitials(name: name)
            return data
        } catch {
            print("get initials error: \(error.localizedDescription)")
            return nil
        }
    }
    
    public func onLogout() async throws {
        do {
            let _ = try await account.deleteSession(sessionId: "current")
            self.currentUser = nil
            self.isAuthenticated = false
        } catch {
            throw AuthError.signOutFailed
        }
    }
    
    public func listDocument(_ collectionId: String, _ documentId: String) async throws -> Document<[String: AnyCodable]>? {
        do {
            let document = try await databases.getDocument(databaseId: databaseId, collectionId: collectionId, documentId: documentId)
            return document
        } catch {
            print(error.localizedDescription)
            throw FetchDocumentsError.failedFetch
        }
    }
    
    public func listDocuments(_ collectionId: String) async throws -> DocumentList<[String: AnyCodable]>? {
        do {
            let documentList = try await databases.listDocuments(
                databaseId: databaseId,
                collectionId: collectionId,
                queries: [] // optional
            )
            return documentList
        } catch {
            print(error.localizedDescription)
            throw FetchDocumentsError.failedFetch
        }
    }
    
    public func createDocument(_ collectionId: String, _ documentId: String, _ data: String) async throws -> Document<[String: AnyCodable]>? {
        
        do {
            let document = try await databases.createDocument(databaseId: databaseId, collectionId: collectionId, documentId: documentId, data: data)
            return document
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func updateDocument(_ collectionId: String, _ documentId: String, _ data: String) async throws -> Document<[String: AnyCodable]>? {
        do {
            let document = try await databases.updateDocument(databaseId: databaseId, collectionId: collectionId, documentId: documentId, data: data)
            return document
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    public func deleteDocument(_ collectionId: String, _ documentId: String) async throws {
        do {
            let _ = try await databases.deleteDocument(databaseId: databaseId, collectionId: collectionId, documentId: documentId)
        } catch {
            print(error.localizedDescription)
        }
    }
}

enum AuthError: LocalizedError {
    case invalidCredentials, userBlocked, signOutFailed, generalArgumentError
    
    var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "The email or password you entered is incorrect. Please try again."
        case .userBlocked:
            return "Your account has been temporarily suspended. Please contact support"
        case .generalArgumentError:
            return "Password must be at least 8 characters long"
        case .signOutFailed:
            return "Failed to sign out. Please try again."
        }
    }
}

enum UserError: LocalizedError {
    case failed(String)
    case invalidEmail
    case invalidPassword
    case passwordMismatch
    
    var errorDescription: String? {
        switch self {
        case .failed(let message):
            return "\(message)"
        case .invalidEmail:
            return "Invalid email format. Must be a valid email address."
        case .invalidPassword:
            return "Invalid password. Must be at least 8 characters long."
        case .passwordMismatch:
            return "Passwords do not match. Please try again."
        }
    }
}

enum DeleteDocumentError: LocalizedError {
    case failedDelete
    
    var errorDescription: String? {
        return "Failed to delete document.  Please try again."
    }
    
}

enum FetchDocumentsError: LocalizedError {
    case failedFetch
    
    var errorDescription: String? {
        return "Failed to load protocols.  Please try again."
    }
}



