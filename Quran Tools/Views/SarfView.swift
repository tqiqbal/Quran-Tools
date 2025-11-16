//
//  SarfView.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import SwiftUI

struct SarfView: View {
    @StateObject private var viewModel = SarfViewModel()
    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        NavigationView {
            ZStack {
                Theme.backgroundColor.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Header
                        headerSection

                        // Info Box
                        infoBox

                        // Search Form
                        searchForm

                        // Error Message
                        if let error = viewModel.errorMessage {
                            errorView(message: error)
                        }

                        // Results
                        if viewModel.showResults {
                            resultsSection
                        }
                    }
                    .padding()
                }
                .onTapGesture {
                    isTextFieldFocused = false
                }
            }
            .navigationTitle("تحليل الصرف")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("تم") {
                        isTextFieldFocused = false
                    }
                    .foregroundColor(Theme.primaryColor)
                    .fontWeight(.semibold)
                }
            }
        }
    }

    // MARK: - Header Section
    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("تحليل الصرف")
                .font(Theme.titleFont)
                .foregroundColor(Theme.primaryColor)
                .environment(\.layoutDirection, .rightToLeft)

            Text("Arabic Morphology Analysis")
                .font(Theme.bodyFont)
                .foregroundColor(Theme.secondaryColor.opacity(0.7))
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 8)
    }

    // MARK: - Info Box
    private var infoBox: some View {
        InfoBanner(
            title: "كيفية الاستخدام:",
            message: "أدخل كلمة عربية لتحليلها صرفياً - مثال: رددنا"
        )
        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Search Form
    private var searchForm: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Label {
                    Text("الكلمة العربية")
                        .font(Theme.bodyFont)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "character.cursor.ibeam")
                        .foregroundColor(Theme.primaryColor)
                }
                .environment(\.layoutDirection, .rightToLeft)

                TextField("مثال: رددنا", text: $viewModel.searchWord)
                    .font(Theme.arabicLargeFont)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                isTextFieldFocused ? Theme.primaryColor : Theme.primaryColor.opacity(0.3),
                                lineWidth: isTextFieldFocused ? 2 : 1
                            )
                    )
                    .focused($isTextFieldFocused)
                    .environment(\.layoutDirection, .rightToLeft)
                    .submitLabel(.search)
                    .onSubmit {
                        isTextFieldFocused = false
                        Task {
                            await viewModel.analyzeSarf()
                        }
                    }
            }

            GradientButton(
                title: "تحليل",
                icon: "magnifyingglass.circle.fill",
                action: {
                    isTextFieldFocused = false
                    Task {
                        await viewModel.analyzeSarf()
                    }
                },
                isLoading: viewModel.isLoading,
                isDisabled: viewModel.searchWord.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            )
            .environment(\.layoutDirection, .rightToLeft)
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }

    // MARK: - Results Section
    private var resultsSection: some View {
        VStack(spacing: 16) {
            HStack {
                Image(systemName: "text.magnifyingglass")
                    .foregroundColor(Theme.primaryColor)
                Text("نتائج التحليل")
                    .font(Theme.headingFont)
                    .foregroundColor(Theme.secondaryColor)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .environment(\.layoutDirection, .rightToLeft)

            if viewModel.morphologyResults.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("لم يتم العثور على نتائج")
                        .font(Theme.bodyFont)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(40)
                .background(Color.white)
                .cornerRadius(12)
                .environment(\.layoutDirection, .rightToLeft)
            } else {
                ForEach(viewModel.morphologyResults) { word in
                    morphologyCard(word)
                }
            }
        }
    }

    // MARK: - Morphology Card
    private func morphologyCard(_ word: MorphologyWord) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Vocalized Form (Main Display)
            HStack {
                Spacer()
                Text(word.vocForm)
                    .font(Theme.arabicLargeFont)
                    .foregroundColor(Theme.primaryColor)
                Spacer()
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Theme.primaryColor.opacity(0.1), Theme.primaryColor.opacity(0.05)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(10)
            .environment(\.layoutDirection, .rightToLeft)

            Divider()

            // Morphology Details
            VStack(spacing: 12) {
                morphologyRow(
                    icon: "text.book.closed",
                    label: "المعنى",
                    value: word.niceGloss ?? word.gloss,
                    isArabic: false
                )

                Divider()

                morphologyRow(
                    icon: "tag.fill",
                    label: "نوع الكلمة",
                    value: word.posNice,
                    isArabic: false
                )

                Divider()

                morphologyRow(
                    icon: "leaf.fill",
                    label: "الجذر",
                    value: word.root,
                    isArabic: true
                )

                if let measure = word.measure, !measure.isEmpty {
                    Divider()
                    morphologyRow(
                        icon: "scalemass.fill",
                        label: "الوزن",
                        value: measure,
                        isArabic: false
                    )
                }
            }
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Theme.primaryColor.opacity(0.2), lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.06), radius: 6, x: 0, y: 2)
    }

    // MARK: - Morphology Row
    private func morphologyRow(icon: String, label: String, value: String, isArabic: Bool) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Theme.primaryColor)
                .font(.system(size: 16))
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 6) {
                Text(label)
                    .font(Theme.smallFont)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.secondaryColor.opacity(0.7))

                Text(value)
                    .font(isArabic ? Theme.arabicFont : Theme.bodyFont)
                    .foregroundColor(Theme.textColor)
                    .lineSpacing(2)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .environment(\.layoutDirection, isArabic ? .rightToLeft : .leftToRight)
        }
        .environment(\.layoutDirection, .rightToLeft)
    }

    // MARK: - Error View
    private func errorView(message: String) -> some View {
        HStack(spacing: 12) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(Theme.errorColor)
                .font(.system(size: 20))
            Text(message)
                .font(Theme.bodyFont)
                .foregroundColor(Theme.errorColor)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Theme.errorColor.opacity(0.1))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Theme.errorColor.opacity(0.3), lineWidth: 1)
        )
        .environment(\.layoutDirection, .rightToLeft)
    }
}

#Preview {
    SarfView()
}
