//
//  HomeTabView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct HomeTabView: View {
    @EnvironmentObject private var appwrite: Appwrite
    //let appwrite: Appwrite
    
    var body: some View {
        TabView {
            Home(appwrite: appwrite)
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
        //.environmentObject(appwrite)
    }
}

//#Preview {
//    let appwrite = Appwrite()
//    HomeTabView(appwrite: appwrite, viewModel: SharedViewModel())
//}
