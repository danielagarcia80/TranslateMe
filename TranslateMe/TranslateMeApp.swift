//
//  TranslateMeApp.swift
//  TranslateMe
//
//  Created by Daniela Garcia on 3/18/25.
//

import SwiftUI
import FirebaseCore // <-- Import Firebase

@main
struct TranslateMeApp: App {
    
    @State private var authManager: AuthManager
    
    init() { // <-- Add an init
        FirebaseApp.configure()
        authManager = AuthManager()
    }
    
    var body: some Scene {
        WindowGroup {
            TranslationView()
                .environment(authManager)
        }
    }
}
