//
//  SignUp.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/13/24.
//

import SwiftUI

struct SignUp: View {
    
    @StateObject var viewModel: SignUpViewModel
    @EnvironmentObject var appwrite: Appwrite
    @State private var isLoading = false
    @State var isShowingSignIn = false
    @State var showHomeTabView = false
    //Alert vars:
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    @FocusState var fnameIsFocused: Bool
    @FocusState var lnameIsFocused: Bool
    @FocusState var emailIsFocused: Bool
    @FocusState var passwordIsFocused: Bool
    @FocusState var password2IsFocused: Bool
    
    init(appwrite: Appwrite){
        _viewModel = StateObject(wrappedValue: SignUpViewModel(appwrite: appwrite))
    }
    
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
                        TextField("First Name", text: $viewModel.firstName, onCommit: {})
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
                        TextField("Last Name", text: $viewModel.lastName, onCommit: {})
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
                        Text("email:")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
                        TextField("email", text: $viewModel.email, onCommit: {})
                            .textFieldStyle(.roundedBorder)
                            .textInputAutocapitalization(.never)
                            .focused($emailIsFocused)
                            .disableAutocorrection(true)
                            .onSubmit {
                                //code:
                            }
                            .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(emailIsFocused ? Color.blue : Color.white, lineWidth: 3)
                            )
                    }
                    VStack(alignment: .leading){
                        Text("Password:")
                            .foregroundColor(.white)
                            .font(Font.custom("Urbanist-Regular", size: 20))
                        SecureField("password", text: $viewModel.password, onCommit: {})
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
                        SecureField("confirm password", text: $viewModel.passwordConfirm, onCommit: {})
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
                        Task {
                            do {
                                let isValidFields = try checkSignUpFields(viewModel.firstName, viewModel.lastName, viewModel.email, viewModel.password, viewModel.passwordConfirm)
                                if isValidFields {
                                    viewModel.isSubmitting = true
                                    do {
                                        try await viewModel.signUp()
                                        viewModel.isSubmitting = false
                                        showHomeTabView = true
                                    } catch {
                                        viewModel.isSubmitting = false
                                        alertMessage = error.localizedDescription
                                        showAlert = true
                                    }
                                }
                            } catch SignUpTextfieldError.emptyFname {
                                isLoading = false
                                fnameIsFocused = true
                                showAlert = true
                                alertMessage = "Please enter your first name"
                            } catch SignUpTextfieldError.emptyLname {
                                isLoading = false
                                lnameIsFocused = true
                                showAlert = true
                                alertMessage = "Please enter your last name"
                            } catch SignUpTextfieldError.emptyEmail {
                                isLoading = false
                                emailIsFocused = true
                                showAlert = true
                                alertMessage = "Please enter your email"
                            } catch SignUpTextfieldError.emptyPassword {
                                isLoading = false
                                passwordIsFocused = true
                                showAlert = true
                                alertMessage = "Please enter your password"
                            } catch SignUpTextfieldError.emptyPassword2 {
                                isLoading = false
                                password2IsFocused = true
                                showAlert = true
                                alertMessage = "Please enter your password confirmation"
                            } catch SignUpTextfieldError.pwordsNotMatched {
                                isLoading = false
                                passwordIsFocused = true
                                showAlert = true
                                alertMessage = "Your passwords do not match!"
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
                            Text("Create Account")
                                .frame(maxWidth: 250)
                                .font(.headline)
                        }
                    }
                    .padding(.vertical, 30)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .alert(isPresented: $showAlert){
                        Alert(title: Text("Account Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
                    }
                    .navigationDestination(isPresented: $showHomeTabView, destination: {HomeTabView()})
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
                    .navigationDestination(isPresented: $isShowingSignIn, destination: {SignIn(appwrite: appwrite)})
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

enum SignUpTextfieldError: Error {
    case emptyFname, emptyLname, emptyEmail, emptyPassword, emptyPassword2, pwordsNotMatched
}

private func checkSignUpFields(
    _ fname: String,
    _ lname: String,
    _ email: String,
    _ password: String,
    _ password2: String
) throws -> Bool {
    if fname.isEmpty {
        throw SignUpTextfieldError.emptyFname
    }
    if lname.isEmpty {
        throw SignUpTextfieldError.emptyLname
    }
    if email.isEmpty {
        throw SignUpTextfieldError.emptyEmail
    }
    if password.isEmpty {
        throw SignUpTextfieldError.emptyPassword
    }
    if password2.isEmpty {
        throw SignUpTextfieldError.emptyPassword2
    } else if password != password2 {
        throw SignUpTextfieldError.pwordsNotMatched
    }
    
    return true
}
