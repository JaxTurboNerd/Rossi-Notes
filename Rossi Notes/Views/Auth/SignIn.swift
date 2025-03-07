//
//  SignIn.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/13/24.
//

import SwiftUI

struct SignIn: View {
    @StateObject private var viewModel: LoginViewModel
    @EnvironmentObject private var appwrite: Appwrite
    //@StateObject var user = Appwrite()
    @State var isShowingSignUp = false
    @State var showHomeTabView = false
    
    //@State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @FocusState var emailIsFocused: Bool
    @FocusState var passwordIsFocused: Bool
    
    init(appwrite: Appwrite){
        _viewModel = StateObject(wrappedValue: LoginViewModel(appwrite: appwrite))
    }
    
    
    var body: some View {
        NavigationStack {
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
                        TextField("email", text: $viewModel.email, onCommit: {})
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                            .focused($emailIsFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(emailIsFocused ? Color.blue : Color.white, lineWidth: 3)
                            )
                    }
                    .padding()
                    VStack(alignment: .leading) {
                        Text("password")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
                        
                        SecureField("password:", text: $viewModel.password, onCommit: {})
                            .textFieldStyle(.roundedBorder)
                            .focused($passwordIsFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(passwordIsFocused ? Color.blue : Color.white, lineWidth: 3)
                            )
                    }
                    .padding()
                    VStack {
                        Button{
                            //action:
                            Task {
                                do {
                                    let isValidFields = try checkLoginFields(viewModel.email, viewModel.password)
                                    
                                    if isValidFields {
                                        //returns a Session Object
                                        viewModel.isSubmitting = true
                                        viewModel.signIn()
                                        showHomeTabView = true
                                    }
                                } catch LoginTextfieldError.emptyEmail{
                                    viewModel.isSubmitting = false
                                    emailIsFocused = true
                                    alertMessage = "Please enter your email"
                                    showAlert = true
                                } catch LoginTextfieldError.emptyPassword {
                                    viewModel.isSubmitting = false
                                    passwordIsFocused = true
                                    alertMessage = "Please enter your password"
                                    showAlert = true
                                } catch {
                                    viewModel.isSubmitting = false
                                    alertMessage = "An error logging in occured"
                                    showAlert = true
                                    await MainActor.run {
                                        viewModel.response = error.localizedDescription
                                    }
                                }
                                
                            }
                        } label: {
                            if viewModel.isSubmitting {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle())
                                    .aspectRatio(contentMode: .fit)
                                    .frame(minWidth: 250, maxWidth: 250, minHeight: 20, maxHeight: 20, alignment: .center)
                            } else {
                                Text("Sign In")
                                    .frame(maxWidth: 250)
                                    .font(.headline)
                            }
                        }
                        .padding()
                        .buttonStyle(.borderedProminent)
                        .controlSize(.large)
                        .alert(isPresented: $showAlert){
                            Alert(title: Text("Login Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                        }
                    }
                    .navigationDestination(isPresented: $showHomeTabView, destination: {HomeTabView(appwrite: appwrite)})
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
                    }
                    .navigationDestination(isPresented: $isShowingSignUp, destination: {SignUp(appwrite: appwrite)})
                }
            }
            .ignoresSafeArea(.all)
            .onTapGesture {
                self.dismissKeyboard()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

enum LoginTextfieldError: Error {
    case emptyEmail, emptyPassword
}

private func checkLoginFields(_ email: String, _ password: String) throws -> Bool {
    if email.isEmpty {
        throw LoginTextfieldError.emptyEmail
    } else if password.isEmpty {
        throw LoginTextfieldError.emptyPassword
    }
    return true
}
