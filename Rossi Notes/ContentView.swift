//
//  ContentView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject var user: Appwrite
    @State var isShowingSignIn = false
    
    var body: some View {
        NavigationStack {
            if user.isLoading {
                ProgressView()
            } else if user.isAuthenticated {
                HomeTabView(appwrite: user)
            } else {
                ZStack {
                    MainBackgroundView()
                    VStack{
                        Spacer()
                        Text("Protcol Notes")
                            .font(Font.custom("ConcertOne-Regular", size: 38))
                        Spacer()
                        Image("WalkTheDog")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                        Text("A collaborative tool to stay updated on dog walking protocols.")
                            .multilineTextAlignment(.center)
                            .font(Font.custom("Urbanist-Medium", size: 20))
                            .padding()
                        Divider()
                            .frame(height: 2)
                            .overlay(.gray)
                        Spacer()
                        VStack {
                            Button{
                                isShowingSignIn = true
                            } label: {
                                Text("Sign In")
                                    .frame(maxWidth: 250)
                                    .font(.headline)
                            }
                            .padding()
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        .navigationDestination(isPresented: $isShowingSignIn, destination: {SignIn(appwrite: user)})
                        Spacer()
                    }
                    .padding()
                }
                .navigationBarBackButtonHidden()
                
            }
        }
    }
}

struct MainBackgroundView: View {
    
    var body: some View {
        Color("BackgroundMain")//custom color with dark mode support
            .ignoresSafeArea(.all)
    }
}

#Preview {
    @Previewable @StateObject var appwrite = Appwrite()
    ContentView(user: appwrite)
}
