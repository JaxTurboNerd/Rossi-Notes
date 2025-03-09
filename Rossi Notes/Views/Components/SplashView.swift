//
//  SplashView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 3/8/25.
//

import SwiftUI

struct SplashView: View {
    @StateObject var appwrite: Appwrite
    @State var shouldDisplaySplashView = true
    
    var body: some View {
        VStack {
            if self.shouldDisplaySplashView {
                SplashContent(user: appwrite)
            } else {
                ContentView(user: appwrite)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5, execute: {
                withAnimation {
                    self.shouldDisplaySplashView = false
                }
            })
        }

    }
}

#Preview {
    @Previewable @StateObject var appwrite = Appwrite()
    SplashView(appwrite: appwrite)
}
