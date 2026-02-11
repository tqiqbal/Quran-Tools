//
//  QuranAPIService.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import Foundation

class QuranAPIService {
    static let shared = QuranAPIService()
    private var surahCache: [Int: OfflineSurahFile] = [:]

    private init() {}

    // MARK: - Fetch Surahs
    func fetchSurahs() async throws -> [Surah] {
        let index = try loadSurahIndex()
        return index.data.sorted { $0.number < $1.number }
    }

    // MARK: - Fetch Translation
    func fetchTranslation(surah: Int, ayah: Int) async throws -> AyahResponse {
        let surahData = try loadSurahFile(surah)
        guard let ayahData = surahData.ayahs.first(where: { $0.ayahNo == ayah }) else {
            throw OfflineDataError.ayahNotFound(surah: surah, ayah: ayah)
        }

        return AyahResponse(
            surahNumber: surah,
            surahName: surahData.surahNameArabic,
            ayahNumber: ayah,
            arabic: ayahData.arabic,
            english: ayahData.english,
            urdu: ayahData.urdu
        )
    }

    // MARK: - Fetch E'arab Content
    func fetchEarabContent(surah: Int, ayah: Int) async throws -> String {
        let surahData = try loadSurahFile(surah)
        guard let ayahData = surahData.ayahs.first(where: { $0.ayahNo == ayah }) else {
            throw OfflineDataError.ayahNotFound(surah: surah, ayah: ayah)
        }

        guard let earab = ayahData.earab else {
            throw OfflineDataError.earabNotFound(surah: surah, ayah: ayah)
        }

        return ([earab.titleHTML] + earab.cardsHTML).joined(separator: "\n")
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

    private func loadSurahFile(_ surahNumber: Int) throws -> OfflineSurahFile {
        if let cached = surahCache[surahNumber] {
            return cached
        }

        let file = try loadJSON(
            filename: "surah-\(surahNumber)",
            subdirectory: "data",
            as: OfflineSurahFile.self
        )
        surahCache[surahNumber] = file
        return file
    }

    private func loadJSON<T: Decodable>(
        filename: String,
        subdirectory: String,
        as type: T.Type
    ) throws -> T {
        let candidates: [URL?] = [
            Bundle.main.url(forResource: filename, withExtension: "json", subdirectory: subdirectory),
            Bundle.main.url(forResource: filename, withExtension: "json")
        ]

        guard let url = candidates.compactMap({ $0 }).first else {
            throw OfflineDataError.fileNotFound(filename: "\(subdirectory)/\(filename).json or \(filename).json")
        }

        let data = try Data(contentsOf: url)
        return try JSONDecoder().decode(type, from: data)
    }

    private func loadSurahIndex() throws -> OfflineSurahIndex {
        if let index = try? loadJSON(
            filename: "surahs-index",
            subdirectory: "data",
            as: OfflineSurahIndex.self
        ) {
            return index
        }

        if let index = try? loadJSON(
            filename: "surah-index",
            subdirectory: "data",
            as: OfflineSurahIndex.self
        ) {
            return index
        }

        throw OfflineDataError.fileNotFound(filename: "data/surahs-index.json (or data/surah-index.json)")
    }
}

private enum OfflineDataError: LocalizedError {
    case fileNotFound(filename: String)
    case ayahNotFound(surah: Int, ayah: Int)
    case earabNotFound(surah: Int, ayah: Int)

    var errorDescription: String? {
        switch self {
        case let .fileNotFound(filename):
            return "Offline data file is missing: \(filename)"
        case let .ayahNotFound(surah, ayah):
            return "Ayah \(ayah) was not found in Surah \(surah) offline data."
        case let .earabNotFound(surah, ayah):
            return "E'arab content is not available offline for Surah \(surah), Ayah \(ayah)."
        }
    }
}

private struct OfflineSurahIndex: Decodable {
    let data: [Surah]
}

private struct OfflineSurahFile: Decodable {
    let surahNo: Int
    let surahName: String
    let surahNameArabic: String
    let ayahs: [OfflineAyah]
}

private struct OfflineAyah: Decodable {
    let ayahNo: Int
    let arabic: String
    let english: String
    let urdu: String
    let earab: OfflineEarab?
}

private struct OfflineEarab: Decodable {
    let titleHTML: String
    let cardsHTML: [String]

    enum CodingKeys: String, CodingKey {
        case titleHTML = "title_html"
        case cardsHTML = "cards_html"
    }
}
