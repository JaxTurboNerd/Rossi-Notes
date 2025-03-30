//
//  HomeTabView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct HomeTabView: View {
    private var appwrite: Appwrite
    
    init(appwrite: Appwrite){
        self.appwrite = appwrite
    }
    
    var body: some View {
        TabView {
            Home(appwrite: appwrite)
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

#Preview {
    let appwrite = Appwrite()
    HomeTabView(appwrite: appwrite)
}
