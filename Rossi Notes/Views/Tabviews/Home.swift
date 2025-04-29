//
//  Home.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct Home: View {
    
    private var appwrite: Appwrite
    @StateObject var viewModel: HomeTabViewModel
    @State var isShowingHomeView = false
    @State private var showAlert = false
    @State private var alertMessage = ""
        
    init(appwrite: Appwrite) {
        _viewModel = StateObject(wrappedValue: HomeTabViewModel(appwrite: appwrite))
        self.appwrite = appwrite
    }
    
    var body: some View {
        NavigationStack {
            ZStack{
                MainBackgroundView()
                VStack {
                    Text("Protocol Notes")
                        .font(Font.custom("ConcertOne-Regular", size: 34))
                    Divider()
                        .frame(width: 350, height: 2)
                        .overlay(Color("AppBlue"))
                        .padding(.vertical)
                    Text("Create and share dog protocols!")
                        .font(Font.custom("Urbanist-Medium", size: 22))
                        .padding(.vertical)
                        .multilineTextAlignment(.center)
                    Text("\(viewModel.userName)\n\nPlease check-in with the ACE staff to verify the proper protocols and dates.")
                        .multilineTextAlignment(.center)
                        .font(Font.custom("Urbanist-Medium", size: 18))
                        .frame(minWidth: 300, minHeight: 100)
                        .padding()
                        .background(Color("AppBlue"))
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    Spacer()
                    Button{
                        //action:
                        Task {
                            do {
                                try await viewModel.signOut()
                                appwrite.isAuthenticated = false
                                isShowingHomeView = true
                            } catch {
                                viewModel.isSubmitting = false
                                alertMessage = error.localizedDescription
                                showAlert = true
                            }
                        }
                        
                    } label: {
                        Text("Sign Out")
                            .frame(maxWidth: 250)
                            .font(.headline)
                        Image("sign-out-thin")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 25)
                    }
                    .padding(.bottom, 50)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
                .navigationDestination(isPresented: $isShowingHomeView, destination: {ContentView()})
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    let appwwrite = Appwrite()
    Home(appwrite: appwwrite)
}
