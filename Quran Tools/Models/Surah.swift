//
//  Surah.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import Foundation

struct Surah: Codable, Identifiable, Hashable {
    let number: Int
    let name: String
    let englishName: String
    let englishNameTranslation: String
    let numberOfAyahs: Int
    let revelationType: String

    var id: Int { number }

    enum CodingKeys: String, CodingKey {
        case number
        case name
        case englishName
        case englishNameTranslation
        case numberOfAyahs
        case revelationType
    }
}

struct SurahListResponse: Codable {
    let code: Int
    let status: String
    let data: [Surah]
}
