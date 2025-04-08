//
//  Appwrite.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/30/24.
//

import Foundation
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
    private var databaseId = "66a04cba001cb48a5bd7"
    @Published var currentUser: User<[String: AnyCodable]>?
    //@Published var session: Session?
    @Published var isAuthenticated = false
    @Published var isLoading = false
    
    public init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("66a04859001d3df0988d")
        
        self.account = Account(client)
        self.avatars = Avatars(client)
        self.databases = Databases(client)
    }
    
    func checkAuthStatus() async {
        isLoading = true
        do {
            currentUser = try await account.get()
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
        } catch {
            throw UserError.failed(error.localizedDescription)
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
            let user = try await account.get()
            self.currentUser = user
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
    
    public func getInitials() async throws -> ByteBuffer? {
        do {
            //returns a ByteBuffer Object
            let bytes = try await avatars.getInitials(width: 40)
            return bytes
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
    case invalidEmail(String)
    case invalidPassword(String)
    
    var errorDescription: String? {
        switch self {
        case .failed(let message):
            return "\(message)"
        case .invalidEmail(let message):
            return "\(message)"
        case .invalidPassword(let message):
            return "\(message)"
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


