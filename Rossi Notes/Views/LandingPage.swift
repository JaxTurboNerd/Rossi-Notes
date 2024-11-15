//
//  LandingPage.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/14/24.
//

import SwiftUI

struct LandingPage: View {
    
    @State var isShowingSignIn = false
    
    var body: some View {
        NavigationView {
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
                    Text("Create, Update or Delete notes for each protocol dog!")
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Urbanist-Medium", size: 20))
                        .padding()
                    Divider()
                    Spacer()
                    VStack {
                        Button{
                            //action:
                            isShowingSignIn = true
                            
                        } label: {
                            Text("Sign In")
                                .frame(maxWidth: 250)
                                .font(.headline)
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        NavigationLink(destination: SignIn(), isActive: $isShowingSignIn){EmptyView()}
                    }
                    Spacer()
                }
                .padding()
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
    LandingPage()
}
