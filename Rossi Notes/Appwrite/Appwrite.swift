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

class Appwrite: ObservableObject {
    //initialize appwrite:
    var client: Client
    var account: Account
    var avatars: Avatars
    var databases: Databases
    private var databaseId = "66a04cba001cb48a5bd7"
//    private var plusCollectionId = "66a402a0003ddfe36884"
    
    public init() {
        self.client = Client()
            .setEndpoint("https://cloud.appwrite.io/v1")
            .setProject("66a04859001d3df0988d")
        
        self.account = Account(client)
        self.avatars = Avatars(client)
        self.databases = Databases(client)
        
        
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
    
    public func getInitials() async throws -> ByteBuffer {
        //returns a ByteBuffer Object
        let bytes = try await avatars.getInitials(width: 40)
        //print("get initial bytes: \(bytes)")
        let allocator = ByteBufferAllocator()
        var buffer = allocator.buffer(capacity: 803)
        if let readBytes = buffer.readBytes(length: 803){//not working!
            print("read bytes: \(readBytes)")
        }
        return bytes
    }
    
    public func onLogout() async throws {
        _ = try await account.deleteSession(
            sessionId: "current"
        )
    }
    
    public func getNotesList(_ collectionId: String) async throws -> DocumentList<[String: AnyCodable]> {
        return try await databases.listDocuments(
            databaseId: databaseId,
            collectionId: collectionId,
            queries: [] // optional
        )
    }
}


