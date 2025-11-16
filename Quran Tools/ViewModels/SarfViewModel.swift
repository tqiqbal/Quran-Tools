//
//  SarfViewModel.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import Foundation

@MainActor
class SarfViewModel: ObservableObject {
    @Published var searchWord: String = ""
    @Published var morphologyResults: [MorphologyWord] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var showResults = false

    private let apiService = QuranAPIService.shared

    func analyzeSarf() async {
        guard !searchWord.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "الرجاء إدخال كلمة"
            return
        }

        isLoading = true
        errorMessage = nil
        showResults = false

        do {
            morphologyResults = try await apiService.fetchMorphology(word: searchWord)
            showResults = true

            if morphologyResults.isEmpty {
                errorMessage = "لم يتم العثور على نتائج"
            }
        } catch {
            errorMessage = "فشل في تحليل الكلمة: \(error.localizedDescription)"
            showResults = false
        }

        isLoading = false
    }
}
