//
//  Translation.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import Foundation

struct Translation: Codable {
    let arabic1: String
    let english: TranslationDetail
    let urdu: TranslationDetail

    struct TranslationDetail: Codable {
        let text: String
        let translatorName: String?
    }
}

struct AyahResponse: Codable {
    let surahNumber: Int
    let surahName: String
    let ayahNumber: Int
    let arabic: String
    let english: String
    let urdu: String
}
