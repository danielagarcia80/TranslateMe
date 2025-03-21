//
//  FirestoreManager.swift
//  TranslateMe
//
//  Created by Daniela Garcia on 3/19/25.
//

import Foundation
import FirebaseFirestore

class FirestoreManager: ObservableObject {
    private let db = Firestore.firestore()
    private let collectionName = "translations"
    
    @Published var translations: [Translation] = []
    
    init() {
        fetchTranslations()
    }
    
    func saveTranslation(original: String, translated: String) {
        let translation: [String: Any] = [
            "originalText": original,
            "translatedText": translated,
            "timestamp": Timestamp()
        ]
        
        db.collection(collectionName).addDocument(data: translation) { error in
            if let error = error {
                print("Error saving translation: \(error.localizedDescription)")
            } else {
                self.fetchTranslations()
            }
        }
    }
    
    func fetchTranslations() {
        db.collection(collectionName).order(by: "timestamp", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching translations: \(error.localizedDescription)")
                    return
                }
                
                self.translations = snapshot?.documents.compactMap { document in
                    let data = document.data()
                    guard let originalText = data["originalText"] as? String,
                          let translatedText = data["translatedText"] as? String else { return nil }
                    return Translation(id: document.documentID, originalText: originalText, translatedText: translatedText)
                } ?? []
            }
    }
    
    func clearHistory() {
        db.collection(collectionName).getDocuments { snapshot, error in
            if let error = error {
                print("Error clearing history: \(error.localizedDescription)")
                return
            }
            
            snapshot?.documents.forEach { document in
                self.db.collection(self.collectionName).document(document.documentID).delete { error in
                    if let error = error {
                        print("Error deleting document: \(error.localizedDescription)")
                    }
                }
            }
            self.translations.removeAll()
        }
    }
}

struct Translation: Identifiable {
    var id: String
    var originalText: String
    var translatedText: String
}
