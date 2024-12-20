//
//  ContentView.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/12/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var user: Appwrite
    @State var isShowingSignIn = false
    // @State private var isLoggedIn = false
    //let appwrite = Appwrite()
    
    var body: some View {
        NavigationStack {
            if user.isLoggedIn {
                HomeTabView()
            } else {
                ZStack {
                    BackgroundView()
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
                                //action:
                                isShowingSignIn = true
                                //                                Task {
                                //                                    do {
                                //                                        try await user.getAccount()
                                //                                    }catch {
                                //                                        print(error)
                                //                                    }
                                //
                                //                                }
                                
                            } label: {
                                Text("Sign In")
                                    .frame(maxWidth: 250)
                                    .font(.headline)
                            }
                            .padding()
                            .buttonStyle(.borderedProminent)
                            .controlSize(.large)
                        }
                        .navigationDestination(isPresented: $isShowingSignIn, destination: {SignIn()})
                        Spacer()
                    }
                    .padding()
                }
                .navigationBarBackButtonHidden()
                
            }
        }
    }
}

struct BackgroundView: View {
    
    var body: some View {
        Color("BackgroundMain")//custom color with dark mode support
            .ignoresSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
