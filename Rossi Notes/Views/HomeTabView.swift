//
//  HomeTabView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct HomeTabView: View {
    var body: some View {
           TabView {
               Home()
                   .tabItem {
                       Label("Home", systemImage: "house")
                   }
                   .tag("home")
               Text("Protocol")
                   .tabItem {
                       Label("Protocol", systemImage: "dog")
                   }
                   .tag("protocol")
               Text("Protocol Plus")
                   .tabItem {
                       Label("Protocol +", systemImage: "cross")
                   }
                   .tag("plus")
           }
           .navigationBarBackButtonHidden()
       }
}

#Preview {
    HomeTabView()
}
