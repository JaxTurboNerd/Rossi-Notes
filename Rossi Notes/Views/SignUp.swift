//
//  SignUp.swift
//  Rossi Notes
//
//  Created by Gregory Boyd on 11/13/24.
//

import SwiftUI

struct SignUp: View {
    var body: some View {
        ZStack {
            Color("SignInBG")
            Text("Sign Up").foregroundColor(.white)
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    SignUp()
}
