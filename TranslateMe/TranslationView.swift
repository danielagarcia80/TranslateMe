//
//  TranslationView.swift
//  TranslateMe
//
//  Created by Daniela Garcia on 3/19/25.
//

import SwiftUI

struct TranslationView: View {
    @State private var inputText: String = ""
    @State private var translatedText: String = ""
    @State private var sourceLang: String = "en"
    @State private var targetLang: String = "es"
    @StateObject private var firestoreManager = FirestoreManager()
    private let translationService = TranslationService()
    
    let languageOptions: [String: String] = [
        "English": "en",
        "Spanish": "es",
        "French": "fr",
        "German": "de",
        "Italian": "it",
        "Portuguese": "pt",
        "Dutch": "nl"
    ]
    
    var body: some View {
        VStack {
            Text("TranslationMe")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.blue)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
            HStack {
                VStack {
                    Text("From:")
                        .font(.headline)
                    Picker("Source Language", selection: $sourceLang) {
                        ForEach(languageOptions.sorted(by: <), id: \ .key) { key, value in
                            Text(key).tag(value)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding()
                
                VStack {
                    Text("To:")
                        .font(.headline)
                    Picker("Target Language", selection: $targetLang) {
                        ForEach(languageOptions.sorted(by: <), id: \ .key) { key, value in
                            Text(key).tag(value)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
                .padding()
            }
            .background(Color.white)
            .cornerRadius(10)
            
            TextField("Enter text to translate", text: $inputText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.blue, lineWidth: 1))
                
            Button("Translate") {
                translateText()
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue)
            .cornerRadius(10)
            
            Text("Translated: \(translatedText)")
                .font(.title2)
                .foregroundColor(.green)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(10)
                
            List {
                ForEach(firestoreManager.translations) { translation in
                    VStack(alignment: .leading) {
                        Text(translation.originalText)
                            .font(.headline)
                        Text("→ \(translation.translatedText)")
                            .foregroundColor(.gray)
                    }
                }
            }
            .onAppear {
                firestoreManager.fetchTranslations()
            }
            
            Button("Clear History") {
                firestoreManager.clearHistory()
            }
            .foregroundColor(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.red)
            .cornerRadius(10)
        }
        .padding()
        .background(Color(UIColor.systemBackground))
        .cornerRadius(10)
        .shadow(radius: 5)
        .onAppear {
            firestoreManager.fetchTranslations() // Ensure translations load on launch
        }
        .navigationTitle("Translator")
    }
    
    private func translateText() {
        translationService.translateText(text: inputText, from: sourceLang, to: targetLang) { translated in
            if let translated = translated {
                self.translatedText = translated
                firestoreManager.saveTranslation(original: inputText, translated: translated)
            }
        }
    }
}

#Preview {
    TranslationView()
}
