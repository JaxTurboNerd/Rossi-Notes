//
//  SplashView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 3/8/25.
//

import SwiftUI

struct SplashView: View {
    @State var shouldDisplaySplashView = true
    @EnvironmentObject var appwrite: Appwrite
    
    var body: some View {
        VStack {
            if self.shouldDisplaySplashView {
                SplashContent()
            } else {
                ContentView()
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                withAnimation {
                    self.shouldDisplaySplashView = false
                }
            })
        }
        .environmentObject(appwrite)
    }
}

//#Preview {
//    @Previewable @StateObject var appwrite = Appwrite()
//    SplashView(appwrite: appwrite)
//}
