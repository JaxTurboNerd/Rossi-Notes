//
//  Rossi_NotesApp.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/12/24.
//

import SwiftUI

@main
struct Rossi_NotesApp: App {
    var body: some Scene {
        WindowGroup {
            let user = Appwrite()
            ContentView()
                .environmentObject(user)
        }
    }
}

//extends View class to make this function available to all views:
#if canImport(UIKit)
extension View {
//    func hideKeyboard() {
//        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
//    }
    
    func dismissKeyboard() {
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow?.endEditing(true)
    }
}
#endif
