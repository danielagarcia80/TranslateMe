//
//  TranslationService.swift
//  TranslateMe
//
//  Created by Daniela Garcia on 3/19/25.
//

import Foundation

class TranslationService {
    func translateText(text: String, from sourceLang: String, to targetLang: String, completion: @escaping (String?) -> Void) {
        let encodedText = text.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        let urlString = "https://api.mymemory.translated.net/get?q=\(encodedText)&langpair=\(sourceLang)|\(targetLang)"
        
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("No data received")
                completion(nil)
                return
            }
            
            do {
                let result = try JSONDecoder().decode(TranslationResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(result.responseData.translatedText)
                }
            } catch {
                print("Error decoding translation response: \(error.localizedDescription)")
                completion(nil)
            }
        }.resume()
    }
    
    func getAvailableLanguages() -> [String: String] {
        return [
            "English": "en",
            "Spanish": "es",
            "French": "fr",
            "German": "de",
            "Italian": "it",
            "Portuguese": "pt",
            "Dutch": "nl"
        ]
    }
}

struct TranslationResponse: Codable {
    let responseData: TranslationData
}

struct TranslationData: Codable {
    let translatedText: String
}
