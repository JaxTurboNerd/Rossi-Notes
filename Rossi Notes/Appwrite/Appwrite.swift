//
//  Appwrite.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/30/24.
//

import Foundation
import Appwrite
import AppwriteEnums
import JSONCodable

class Appwrite: ObservableObject {
    //initialize appwrite:
    var client: Client
    var account: Account
    var avatars: Avatars
    
    public init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("66a04859001d3df0988d")
        
        self.account = Account(client)
        self.avatars = Avatars(client)
    }
    
    @Published var user: User<[String: AnyCodable]>?
    @Published var session: Session?
    @Published var isLoggedIn = false
    
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
        return try await account.get()
    }
    
    public func signIn(
        _ email: String,
        _ password: String
    ) async throws -> Session {
        try await account.createEmailPasswordSession(
            email: email,
            password: password
        )
    }
    
    public func getInitials() async throws {
        let bytes = try await avatars.getInitials(width: 40)
    }
    
    public func onLogout() async throws {
        _ = try await account.deleteSession(
            sessionId: "current"
        )
    }
    
}


