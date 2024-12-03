//
//  Appwrite.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/30/24.
//

import Foundation
import Appwrite
import JSONCodable

class Appwrite {
    var client: Client
    var account: Account
    
    public init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("66a04859001d3df0988d")
        
        self.account = Account(client)
    }
    
    
    //creates a new account
    public func createAccount(
        _ firstName: String,
        _ lastName: String,
        _ email: String,
        _ password: String
    ) async -> Bool {
        do {
            let name = firstName + " " + lastName
            let _ = try await account.create(
                userId: ID.unique(),
                email: email,
                password: password,
                name: name
            )
            return true
        } catch {
            print("Error: \(error)")
            //Will need to catch the various types of errors: user exists, etc
            return false
        }
    }
    
    public func getAccount() async {
        do {
            let user = try await account.get()
            print(user)
        } catch {
            print("Error: \(error)")
        }
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
    
    public func onLogout() async throws {
        _ = try await account.deleteSession(
            sessionId: "current"
        )
    }
    
}


