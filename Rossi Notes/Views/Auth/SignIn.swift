//
//  SignIn.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/13/24.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
}

enum LoginTextfieldError: Error {
    case emptyEmail, emptyPassword
}

struct UserSession: Codable {
    let id: String
    let createdAt: String
    let updatedAt: String
    let userID: String
    let expire: String
}

struct SignIn: View {
    
    //    @State var email = ""
    //    @State var password = ""
    @ObservedObject var viewModel = LoginViewModel()
    let appwrite = Appwrite()
    
    @State var isShowingSignUp = false
    @State var isLoggedIn = false //need to make observable throughout the app?
    @State private var isLoading = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @FocusState var emailIsFocused: Bool
    @FocusState var passwordIsFocused: Bool
    
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
                                        isLoading = true
                                        //returns a Session JSON Object
                                        let loginSession = try await appwrite.signIn(viewModel.email, viewModel.password)
                                        print("session creation: \(loginSession.createdAt)")
                                        isLoggedIn = true
                                    }
                                } catch LoginTextfieldError.emptyEmail{
                                    alertMessage = "Please enter your email"
                                    showAlert = true
                                } catch LoginTextfieldError.emptyPassword {
                                    alertMessage = "Please enter your password"
                                    showAlert = true
                                } catch {
                                    isLoading = false
                                    alertMessage = "An error logging in occured"
                                    showAlert = true
                                }
                                
                            }
                        } label: {
                            if isLoading {
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
                    .navigationDestination(isPresented: $isLoggedIn, destination: {HomeTabView()})
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
                    .navigationDestination(isPresented: $isShowingSignUp, destination: {SignUp()})
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

private func checkLoginFields(_ email: String, _ password: String) throws -> Bool {
    if email.isEmpty {
        throw LoginTextfieldError.emptyEmail
    } else if password.isEmpty {
        throw LoginTextfieldError.emptyPassword
    }
    return true
}

#Preview {
    SignIn()
}
