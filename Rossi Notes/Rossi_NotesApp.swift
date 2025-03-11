//
//  Rossi_NotesApp.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/12/24.
//

import SwiftUI

@main
struct Rossi_NotesApp: App {
    let appwrite = Appwrite()
    @StateObject private var detailsModel = DetailsModel()
    var body: some Scene {
        WindowGroup {
            SplashView(appwrite: appwrite)
                .environmentObject(appwrite)
                .environmentObject(detailsModel)
        }
    }
}

//extends View class to make this function available to all views:
#if canImport(UIKit)
extension View {
    
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
