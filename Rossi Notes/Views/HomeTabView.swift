//
//  HomeTabView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct HomeTabView: View {
    let appwrite: Appwrite
    @StateObject var viewModel = SharedViewModel()
    
    var body: some View {
        TabView {
            Home(appwrite: appwrite)
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            ProtocolView(viewModel: viewModel)
                .tabItem {
                    Label("Protocol", systemImage: "dog")
                }
            ProtocolPlusView(appwrite: appwrite)
                .tabItem {
                    Label("Protocol +", systemImage: "cross")
                }
        }
        .navigationBarBackButtonHidden()
        .environmentObject(appwrite)
    }
}

//#Preview {
//    let appwrite = Appwrite()
//    HomeTabView(appwrite: appwrite, viewModel: SharedViewModel())
//}
