//
//  SignUp.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/13/24.
//

import SwiftUI

struct SignUp: View {
    
    @State var firstName = ""
    @State var lastName = ""
    @State var password =  ""
    @State var passwordConfirm = ""
    @State var isShowingSignIn = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color("SignInBG")
                VStack {
                    Text("Create an Account")
                        .foregroundColor(.white)
                        .font(Font.custom("Urbanist-Regular", size: 28))
                        .padding(.vertical)
                    VStack(alignment: .leading){
                        Text("First Name:")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
                        TextField("First Name", text: $firstName, onCommit: {})
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.words)
                            .onSubmit {
                                //code:
                            }
                            .disableAutocorrection(true)
                    }
                    VStack(alignment: .leading){
                        Text("Last Name:")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
                        TextField("Last Name", text: $lastName, onCommit: {})
                            .textFieldStyle(.roundedBorder)
                    }
                    VStack(alignment: .leading){
                        Text("Password:")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
                        SecureField("password", text: $password, onCommit: {})
                            .textFieldStyle(.roundedBorder)
                    }
                    VStack(alignment: .leading){
                        Text("Confirm Password")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
                        SecureField("confirm password", text: $passwordConfirm, onCommit: {})
                            .textFieldStyle(.roundedBorder)
                    }
                    Button{
                        //action:
                        
                    } label: {
                        Text("Create Account")
                            .frame(maxWidth: 250)
                            .font(.headline)
                    }
                    .padding(.vertical, 30)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    Divider()
                        .frame(width: 350, height: 2)
                        .overlay(Color("AppBlue"))
                        .padding(.vertical)
                    VStack {
                        Text("Alread have an account?")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
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
                    }
                    .navigationDestination(isPresented: $isShowingSignIn, destination: {SignIn()})
                }
                .padding()
                
            }
            .ignoresSafeArea(.all)
            .navigationBarBackButtonHidden()
            .onTapGesture {
                self.dismissKeyboard()

            }
        }
    }
}

#Preview {
    SignUp()
}
