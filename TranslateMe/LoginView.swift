//
//  LoginView.swift
//  TranslateMe
//
//  Created by Daniela Garcia on 3/18/25.
//

import SwiftUI

struct LoginView: View {
    
    @Environment(AuthManager.self) var authManager

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack {
            Text("Welcome!")
                .font(.largeTitle)

            // Email + password fields
            VStack {
                TextField("Email", text: $email)
                SecureField("Password", text: $password)
            }
            .textFieldStyle(.roundedBorder) // <-- Style text fields (applies to both text fields within the VStack)
            .textInputAutocapitalization(.never) // <-- No auto capitalization (can be annoying for emails and passwords)
            .padding(40)

            // Sign up + Login buttons
            HStack {
                Button("Sign Up") {
                    print("Sign up user: \(email), \(password)")
                    // TODO: Sign up user
                    
                    authManager.signUp(email: email, password: password) // <-- Sign up user via authManager


                }
                .buttonStyle(.borderedProminent) // <-- Style button

                Button("Login") {
                    print("Login user: \(email), \(password)")
                    // TODO: Login user
                    
                    authManager.signIn(email: email, password: password) // <-- Sign in user via authManager


                }
                .buttonStyle(.bordered) // <-- Style button
            }
        }
    }
}

#Preview {
    LoginView()
        .environment(AuthManager()) // <-- For the preview to work, pass an instance of AuthManager into the environment
}
