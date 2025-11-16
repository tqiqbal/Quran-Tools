//
//  MorphologyWord.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import Foundation

struct MorphologyResponse: Codable {
    let words: [MorphologyWord]
}

struct MorphologyWord: Codable, Identifiable {
    let form: String
    let vocForm: String
    let gloss: String
    let niceGloss: String?
    let pos: String
    let posAbbr: String?
    let posNice: String
    let lemma: String?
    let root: String
    let measure: String?

    var id: String { form + vocForm + root }

    enum CodingKeys: String, CodingKey {
        case form
        case vocForm = "voc_form"
        case gloss
        case niceGloss = "nice_gloss"
        case pos
        case posAbbr = "pos_abbr"
        case posNice = "pos_nice"
        case lemma
        case root
        case measure
    }
}
