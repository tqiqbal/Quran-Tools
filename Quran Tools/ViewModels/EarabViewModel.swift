//
//  EarabViewModel.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import Foundation

@MainActor
class EarabViewModel: ObservableObject {
    @Published var surahs: [Surah] = []
    @Published var selectedSurah: Surah?
    @Published var currentAyah: Int = 1
    @Published var isLoading = false
    @Published var errorMessage: String?

    // Results
    @Published var earabTitle: String = ""
    @Published var earabCards: [String] = []
    @Published var translation: AyahResponse?
    @Published var showResults = false

    private let apiService = QuranAPIService.shared

    init() {
        Task {
            await loadSurahs()
        }
    }

    func loadSurahs() async {
        isLoading = true
        errorMessage = nil

        do {
            surahs = try await apiService.fetchSurahs()
        } catch {
            errorMessage = "فشل في تحميل السور: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func fetchEarab() async {
        guard let surah = selectedSurah else {
            errorMessage = "الرجاء اختيار سورة"
            return
        }

        guard currentAyah > 0 && currentAyah <= surah.numberOfAyahs else {
            errorMessage = "رقم الآية غير صحيح"
            return
        }

        isLoading = true
        errorMessage = nil
        showResults = false

        do {
            // Fetch E'arab content only
            let html = try await apiService.fetchEarabContent(surah: surah.number, ayah: currentAyah)
            let parsedContent = HTMLParser.parseEarabContent(html: html)
            earabTitle = parsedContent.title
            earabCards = parsedContent.cards

            showResults = true
        } catch {
            errorMessage = "فشل في تحميل الإعراب: \(error.localizedDescription)"
            showResults = false
        }

        isLoading = false
    }

    func navigateAyah(direction: Int) {
        guard let surah = selectedSurah else { return }

        let newAyah = currentAyah + direction

        if newAyah >= 1 && newAyah <= surah.numberOfAyahs {
            currentAyah = newAyah
            Task {
                await fetchEarab()
            }
        }
    }

    func canNavigatePrevious() -> Bool {
        return currentAyah > 1
    }

    func canNavigateNext() -> Bool {
        guard let surah = selectedSurah else { return false }
        return currentAyah < surah.numberOfAyahs
    }

    func getSourceURL() -> URL? {
        guard let surah = selectedSurah else { return nil }
        let urlString = "https://surahquran.com/quran-search/e3rab-aya-\(currentAyah)-sora-\(surah.number).html"
        return URL(string: urlString)
    }
}
