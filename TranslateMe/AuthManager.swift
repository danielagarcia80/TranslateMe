//
//  AuthManager.swift
//  TranslateMe
//
//  Created by Daniela Garcia on 3/18/25.
//

import Foundation

import FirebaseAuth // <-- Import Firebase Auth

@Observable // <-- Make class observable
class AuthManager {

    var user: User?
       
       let isMocked: Bool = false
       
       var isSignedIn: Bool = false
       
       var userEmail: String? {

        // If mocked, return a mocked email string, otherwise return the users email if available
        isMocked ? "daniela@dog.com" : user?.email
    }

    private var handle: AuthStateDidChangeListenerHandle?

    init() {
           handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
               self?.user = user
               self?.isSignedIn = user != nil
           }
       }
       
       deinit {
           if let handle = handle {
               Auth.auth().removeStateDidChangeListener(handle)
           }
       }

    // https://firebase.google.com/docs/auth/ios/start#sign_up_new_users
    func signUp(email: String, password: String) {
        Task {
            do {
                let authResult = try await Auth.auth().createUser(withEmail: email, password: password)
                user = authResult.user // <-- Set the user
            } catch {
                print(error)
            }
        }

    }

    // https://firebase.google.com/docs/auth/ios/start#sign_in_existing_users
    func signIn(email: String, password: String) {
        Task {
            do {
                let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
                user = authResult.user // <-- Set the user
            } catch {
                print(error)
            }
        }
    }

    func signOut() {
        do {
            try Auth.auth().signOut()
            user = nil // <-- Set user to nil after sign out
        } catch {
            print(error)
        }
    }
}
