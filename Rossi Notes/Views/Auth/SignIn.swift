//
//  SignIn.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/13/24.
//

import SwiftUI

struct SignIn: View {
    @ObservedObject private var viewModel: LoginViewModel
    @EnvironmentObject private var appwrite: Appwrite
    @State var isShowingSignUp = false
    @State var showHomeTabView = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    //@State private var rememberMeSelected: Bool = UserDefaults.standard.bool(forKey: "rememberMeSelected")
    
    @FocusState var emailIsFocused: Bool
    @FocusState var passwordIsFocused: Bool
    
    init(appwrite: Appwrite){
        _viewModel = ObservedObject(wrappedValue: LoginViewModel(appwrite: appwrite))
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
                        TextField("email", text: $viewModel.email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                            .focused($emailIsFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(emailIsFocused ? Color.blue : Color.white, lineWidth: 2)
                            )
                        Toggle("remember me", isOn: $viewModel.rememberMeSelected)
                            .toggleStyle(.switch)
                            .foregroundColor(.white)
                            .frame(maxWidth: 200)
                    }
                    .padding()
                    VStack(alignment: .leading) {
                        Text("password")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
                        SecureField("password:", text: $viewModel.password)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .textFieldStyle(.roundedBorder)
                            .focused($passwordIsFocused)
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(passwordIsFocused ? Color.blue : Color.white, lineWidth: 2)
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
                                        viewModel.isSubmitting = true
                                        do {
                                            try await viewModel.signIn()
                                            showHomeTabView = true
                                        } catch {
                                            viewModel.isSubmitting = false
                                            alertMessage = error.localizedDescription
                                            showAlert = true
                                        }
                                    }
                                } catch LoginTextfieldError.emptyEmail{
                                    viewModel.isSubmitting = false
                                    emailIsFocused = true
                                    alertMessage = "Please enter your email"
                                    showAlert = true
                                } catch LoginTextfieldError.invalidEmail {
                                    viewModel.isSubmitting = false
                                    emailIsFocused = true
                                    alertMessage = "Please enter a valid email"
                                    showAlert = true
                                } catch LoginTextfieldError.emptyPassword {
                                    viewModel.isSubmitting = false
                                    passwordIsFocused = true
                                    alertMessage = "Please enter your password"
                                    showAlert = true
                                } catch LoginTextfieldError.invalidPassword {
                                    viewModel.isSubmitting = false
                                    passwordIsFocused = true
                                    alertMessage = "Password is must me at least 8 characters long"
                                    showAlert = true
                                } catch {
                                    viewModel.isSubmitting = false
                                    alertMessage = "An unknown error occurred"
                                    showAlert = true
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
                    .navigationDestination(isPresented: $showHomeTabView, destination: {HomeTabView()})
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
                .padding()
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
    case emptyEmail, emptyPassword, invalidPassword, invalidEmail
}

private func checkLoginFields(_ email: String, _ password: String) throws -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    if email.isEmpty {
        throw LoginTextfieldError.emptyEmail
    } else if !NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: email) {
        print("Sign in view invalid email")
        throw LoginTextfieldError.invalidEmail
    } else if password.isEmpty {
        throw LoginTextfieldError.emptyPassword
    } else if password.count < 9 {
        throw LoginTextfieldError.invalidPassword
    }
    return true
}

#Preview {
    let appwrite = Appwrite()
    SignIn(appwrite: appwrite)
        .environmentObject(Appwrite())
}
