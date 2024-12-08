//
//  HomeTabView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct HomeTabView: View {
    //@Binding var isLoggedIn: Bool
    
    var body: some View {
        TabView {
            Home()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ProtocolView()
                .tabItem {
                    Label("Protocol", systemImage: "dog")
                }
            ProtocolPlusView()
                .tabItem {
                    Label("Protocol +", systemImage: "cross")
                }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    HomeTabView()
}
