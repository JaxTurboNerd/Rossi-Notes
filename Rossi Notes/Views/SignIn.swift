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
                VStack(spacing: 5){
                    HStack {
                        Text("email:")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
                        Spacer()
                    }

                    TextField("email", text: $email, onCommit: {})
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }
                
                VStack(spacing:5) {
                    HStack{
                        Text("password")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))

                        Spacer()
                    }
                    SecureField("password", text: $password, onCommit: {})
                        .textFieldStyle(.roundedBorder)
                        .padding(.horizontal)
                }
                .padding(.vertical)
                VStack {
                    Button{
                        //action:
                        
                    } label: {
                        Text("Sign In")
                            .frame(maxWidth: 250)
                            .font(.headline)
                    }
                    .padding()
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }

            }
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    SignIn()
}
