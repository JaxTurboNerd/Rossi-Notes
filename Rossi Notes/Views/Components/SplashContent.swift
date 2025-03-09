//
//  SplashscreenView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 3/8/25.
//

import SwiftUI

struct SplashContent: View {
    
    @StateObject var user: Appwrite
    @State var shouldDisplaySplashView = true
    
    var body: some View {
        ZStack {
            MainBackgroundView()
            VStack {
                Text("Rossi Notes App")
                    .font(.title)
                    .padding(.top)
                Image("Splashscreen")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    @Previewable @StateObject var appwrite = Appwrite()
    SplashContent(user: appwrite)
}
