//
//  QuranAPIService.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import Foundation

class QuranAPIService {
    static let shared = QuranAPIService()

    private init() {}

    // MARK: - Fetch Surahs
    func fetchSurahs() async throws -> [Surah] {
        let url = URL(string: "https://api.alquran.cloud/v1/surah")!

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(SurahListResponse.self, from: data)
        return response.data
    }

    // MARK: - Fetch Translation
    func fetchTranslation(surah: Int, ayah: Int) async throws -> AyahResponse {
        // Using quranapi.pages.dev as per website
        let urlString = "https://quranapi.pages.dev/api/\(surah)/\(ayah).json"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)

        // Parse the JSON manually since the structure might vary
        let json = try JSONSerialization.jsonObject(with: data) as? [String: Any]

        let arabic = json?["arabic1"] as? String ?? ""
        let englishData = json?["english"] as? [String: Any]
        let urduData = json?["urdu"] as? [String: Any]

        let english = englishData?["text"] as? String ?? ""
        let urdu = urduData?["text"] as? String ?? ""

        return AyahResponse(
            surahNumber: surah,
            surahName: "",
            ayahNumber: ayah,
            arabic: arabic,
            english: english,
            urdu: urdu
        )
    }

    // MARK: - Fetch E'arab Content
    func fetchEarabContent(surah: Int, ayah: Int) async throws -> String {
        let targetURL = "https://surahquran.com/quran-search/e3rab-aya-\(ayah)-sora-\(surah).html"

        // Try multiple CORS proxies as fallback
        let proxies = [
            "https://api.allorigins.win/get?url=",
            "https://corsproxy.io/?",
            "https://thingproxy.freeboard.io/fetch/",
            "https://api.codetabs.com/v1/proxy?quest="
        ]

        for (index, proxy) in proxies.enumerated() {
            do {
                let proxyURL = proxy + targetURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                guard let url = URL(string: proxyURL) else { continue }

                var request = URLRequest(url: url, timeoutInterval: 10)
                request.httpMethod = "GET"

                let (data, _) = try await URLSession.shared.data(for: request)

                // First proxy returns JSON with contents field
                if index == 0 {
                    if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                       let contents = json["contents"] as? String {
                        return contents
                    }
                } else {
                    // Other proxies return raw HTML
                    if let html = String(data: data, encoding: .utf8) {
                        return html
                    }
                }
            } catch {
                // Try next proxy
                continue
            }
        }

        throw URLError(.cannotFindHost)
    }

    // MARK: - Fetch Morphology
    func fetchMorphology(word: String) async throws -> [MorphologyWord] {
        let encodedWord = word.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? word
        let urlString = "https://aratools.com/api/v1/dictionary/lookup/ar/\(encodedWord)?filter_diacritics=true"

        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(MorphologyResponse.self, from: data)
        return response.words
    }
}
