//
//  TranslationService.swift
//  TranslateMe
//
//  Created by Daniela Garcia on 3/19/25.
//

import Foundation

class TranslationService {
    func translateText(text: String, from sourceLang: String, to targetLang: String, completion: @escaping (String?) -> Void) {
        let cleanedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        var components = URLComponents(string: "https://api.mymemory.translated.net/get")!
        components.queryItems = [
            URLQueryItem(name: "q", value: cleanedText),
            URLQueryItem(name: "langpair", value: "\(sourceLang)|\(targetLang)")
        ]

        guard let url = components.url else {
            print("Invalid URL from components")
            completion(nil)
            return
        }

        print("API Request: \(url.absoluteString)") // Debugging

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
