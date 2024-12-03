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
    @Binding var isLoggedIn: Bool
    
    @FocusState var fnameIsFocused: Bool
    @FocusState var lnameIsFocused: Bool
    @FocusState var passwordIsFocused: Bool
    @FocusState var password2IsFocused: Bool
    
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
                            .focused($fnameIsFocused)
                            .onSubmit {
                                //code:
                            }
                            .disableAutocorrection(true)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(fnameIsFocused ? Color.blue : Color.white, lineWidth: 3)
                            )
                    }
                    VStack(alignment: .leading){
                        Text("Last Name:")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
                        TextField("Last Name", text: $lastName, onCommit: {})
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.words)
                            .focused($lnameIsFocused)
                            .disableAutocorrection(true)
                            .onSubmit {
                                //code:
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(lnameIsFocused ? Color.blue : Color.white, lineWidth: 3)
                            )
                    }
                    VStack(alignment: .leading){
                        Text("Password:")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
                        SecureField("password", text: $password, onCommit: {})
                            .textFieldStyle(.roundedBorder)
                            .disableAutocorrection(true)
                            .focused($passwordIsFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(passwordIsFocused ? Color.blue : Color.white, lineWidth: 3)
                            )

                    }
                    VStack(alignment: .leading){
                        Text("Confirm Password")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
                        SecureField("confirm password", text: $passwordConfirm, onCommit: {})
                            .textFieldStyle(.roundedBorder)
                            .disableAutocorrection(true)
                            .focused($password2IsFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(password2IsFocused ? Color.blue : Color.white, lineWidth: 3)
                            )

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
                    .navigationDestination(isPresented: $isShowingSignIn, destination: {SignIn(isLoggedIn: $isLoggedIn)})
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
    SignUp(isLoggedIn: .constant(false))
}
