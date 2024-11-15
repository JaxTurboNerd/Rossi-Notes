//
//  Home.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/13/24.
//

import SwiftUI

struct Home: View {
    var body: some View {
        TabView {
            Text("Home")
                .tabItem {
                    Label("Home", systemImage: "star")
                }
                .tag("home")
            Text("Protocol")
                .tabItem {
                    Label("Protocol", systemImage: "circle")
                }
                .tag("protocol")
            Text("Protocol Plus")
                .tabItem {
                    Label("P+", systemImage: "square")
                }
                .tag("plus")
        }
    }
}

#Preview {
    Home()
}
