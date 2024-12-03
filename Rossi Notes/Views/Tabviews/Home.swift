//
//  Home.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/16/24.
//

import SwiftUI

struct Home: View {
    
    @State var isShowingHomeView = false
    @Binding var isLoggedIn: Bool
    let appwrite = Appwrite()
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Text("Protocol Notes")
                    .font(Font.custom("ConcertOne-Regular", size: 34))
                Divider()
                    .frame(width: 350, height: 2)
                    .overlay(Color("AppBlue"))
                    .padding(.vertical)
                
                Text("Create and updated dog protocols!")
                    .font(Font.custom("Urbanist-Medium", size: 20))
                    .padding(.vertical)
                Text("Please check-in with the ACE staff to verify the proper protocols and dates.")
                    .multilineTextAlignment(.center)
                    .font(Font.custom("Urbanist-Medium", size: 18))
                    .padding([.vertical], 35)
                    .padding([.horizontal], 20)
                    .background(Color("AppBlue"))
                    .foregroundColor(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Spacer(minLength: 250)
                
                Button{
                    //action:
                    Task {
                        do {
                            try await appwrite.onLogout()
                            isLoggedIn = false
                            isShowingHomeView = true
                            
                        } catch {
                            print("logout error")
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
                .padding()
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                Spacer()
                
            }
            .padding()
            .navigationDestination(isPresented: $isShowingHomeView, destination: {ContentView()})
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    Home(isLoggedIn: .constant(false))
}
