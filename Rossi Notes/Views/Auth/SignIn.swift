//
//  SignIn.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/13/24.
//

import SwiftUI

struct SignIn: View {
    
    @State var email = ""
    @State var password = ""
    
    @State var isShowingSignUp = false
    @State var isLogged = false
    
    var body: some View {
        ZStack {
            Color("SignInBG")//sets the background color
            VStack{
                Text("Account Log-in")
                    .foregroundColor(.white)
                    .font(Font.custom("ConcertOne-Regular", size: 34))
                Text("Welcome back!")
                    .foregroundColor(.white)
                    .font(Font.custom("Urbanist-Regular", size: 20))
                    .padding(.vertical)
                VStack(alignment: .leading){
                    Text("email:")
                        .foregroundColor(.white)
                        .font(Font.custom("Urbanist-Regular", size: 20))
                    TextField("email", text: $email, onCommit: {})
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                VStack(alignment: .leading) {
                    Text("password")
                        .foregroundColor(.white)
                        .font(Font.custom("Urbanist-Regular", size: 20))
                    
                    SecureField("password:", text: $password, onCommit: {})
                        .textFieldStyle(.roundedBorder)
                }
                .padding()
                VStack {
                    Button{
                        //action:
                        isLogged = true
                    } label: {
                        Text("Sign In")
                            .frame(maxWidth: 250)
                            .font(.headline)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    NavigationLink(
                        destination: HomeTabView().navigationBarBackButtonHidden(true),
                        isActive: $isLogged){EmptyView()}
                }
                Divider()
                    .frame(width: 350, height: 2)
                    .overlay(Color("AppBlue"))
                    .padding(.vertical)
                Text("Don't have an account?")
                    .foregroundColor(.white)
                    .font(Font.custom("Urbanist-Regular", size: 20))
                VStack {
                    Button{
                        //action:
                        isShowingSignUp = true
                    } label: {
                        Text("Sign Up")
                            .frame(maxWidth: 250)
                            .font(.headline)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    NavigationLink(
                        destination: SignUp()
                            .navigationBarBackButtonHidden(true),
                        isActive: $isShowingSignUp){EmptyView()}
                }
            }
        }
        .ignoresSafeArea(.all)
        //.navigationBarBackButtonHidden(true)
        .onTapGesture {
            self.dismissKeyboard()
        }
        
    }
}

#Preview {
    SignIn()
}
