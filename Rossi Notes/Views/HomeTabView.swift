//
//  HomeTabView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct HomeTabView: View {
    //@Binding var isLoggedIn: Bool
    @StateObject private var appwrite: Appwrite
    
    init(appwrite: Appwrite){
        _appwrite = StateObject(wrappedValue: Appwrite())
    }
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ProtocolView(appwrite: appwrite)
                .tabItem {
                    Label("Protocol", systemImage: "dog")
                }
            ProtocolPlusView(appwrite: appwrite)
                .tabItem {
                    Label("Protocol +", systemImage: "cross")
                }
        }
        .navigationBarBackButtonHidden()
    }
}

//#Preview {
//    HomeTabView()
//}
