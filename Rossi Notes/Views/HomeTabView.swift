//
//  HomeTabView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct HomeTabView: View {
    @EnvironmentObject private var appwrite: Appwrite
    @State private var selectedTab = 0
    
    var body: some View {
        TabView (selection: $selectedTab){
            Group {
                Home(appwrite: appwrite)
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .tag(0)
                ProtocolView(appwrite: appwrite)
                    .tabItem {
                        Label("Protocol", systemImage: "dog")
                    }
                    .tag(1)
                ProtocolPlusView(appwrite: appwrite)
                    .tabItem {
                        Label("Protocol +", systemImage: "cross")
                    }
                    .tag(2)
            }
            .toolbarBackground(.visible, for: .tabBar)
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeTabView()
        .environmentObject(Appwrite())
}
