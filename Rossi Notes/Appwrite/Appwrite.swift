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
    private let account: Account
    private let avatars: Avatars
    private let databases: Databases
    private var databaseId = "66a04cba001cb48a5bd7"
    //private var plusCollectionId = "66a402a0003ddfe36884"
    @Published var currentUser: User<[String: AnyCodable]>?
    //@Published var session: Session?
    @Published var document: Document<[String: AnyCodable]>?
    @Published var createdDocument: Document<[String: AnyCodable]>?
    @Published var updatedDocument: Document<[String: AnyCodable]>?
    @Published var documentList: DocumentList<[String: AnyCodable]>?
    @Published var isAuthenticated = false
    
    public init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("66a04859001d3df0988d")
        
        self.account = Account(client)
        self.avatars = Avatars(client)
        self.databases = Databases(client)
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
    
    //creates a new account
    public func createAccount(
        _ firstName: String,
        _ lastName: String,
        _ email: String,
        _ password: String
    ) async throws -> User<[String: AnyCodable]> {
        let name = firstName + " " + lastName
        return try await account.create(
            userId: ID.unique(),
            email: email,
            password: password,
            name: name
        )
    }
    
    public func getAccount() async throws -> User<[String: AnyCodable]>{
        do {
            let response = try await account.get()
            
            await MainActor.run {
                self.currentUser = response
            }
        } catch {
            print(error.localizedDescription)
        }
        return currentUser!
    }
    
    public func signIn(_ email: String, _ password: String) async throws -> Session {
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
            return session
        } catch {
            throw AuthError.signInFailed(error.localizedDescription)
        }
    }
    
    public func getInitials() async throws -> ByteBuffer {
        //returns a ByteBuffer Object
        let bytes = try await avatars.getInitials(width: 40)
        return bytes
    }
    
    public func onLogout() async throws {
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
    
    public func listDocument(_ collectionId: String, _ documentId: String) async throws -> Document<[String: AnyCodable]>? {
        do {
            let document = try await databases.getDocument(databaseId: databaseId, collectionId: collectionId, documentId: documentId)
            await MainActor.run {
                self.document = document
            }
            return document
        } catch {
            print(error.localizedDescription)
        }
        return self.document
    }
    
    public func listDocuments(_ collectionId: String) async throws -> DocumentList<[String: AnyCodable]>? {
        do {
            let documentList = try await databases.listDocuments(
                databaseId: databaseId,
                collectionId: collectionId,
                queries: [] // optional
            )
            await MainActor.run {
                self.documentList = documentList
            }
            return documentList
        } catch {
            print(error.localizedDescription)
        }
        return self.documentList
    }
    
    public func createDocument(_ collectionId: String, _ documentId: String, _ data: String) async throws -> Document<[String: AnyCodable]>? {
        
        do {
            let document = try await databases.createDocument(databaseId: databaseId, collectionId: collectionId, documentId: documentId, data: data)
            await MainActor.run {
                self.createdDocument = document
            }
        } catch {
            print(error.localizedDescription)
        }
        return createdDocument
    }
    
    public func updateDocument(_ collectionId: String, _ documentId: String, _ data: String) async throws -> Document<[String: AnyCodable]>? {
        do {
            let document = try await databases.updateDocument(databaseId: databaseId, collectionId: collectionId, documentId: documentId, data: data)
            await MainActor.run {
                self.updatedDocument = document
            }
        } catch {
            print(error.localizedDescription)
        }
        return updatedDocument
    }
    
    public func deleteDocument(_ collectionId: String, _ documentId: String) async throws {
        Task {
            do {
                let response = try await databases.deleteDocument(databaseId: databaseId, collectionId: collectionId, documentId: documentId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}


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


