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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    var body: some View {
        Group {
            if isIPad {
                // iPad: No NavigationView (handled by sidebar)
                contentView
            } else {
                // iPhone: Use NavigationView
                NavigationView {
                    contentView
                }
            }
        }
    }

    private var contentView: some View {
        ZStack {
                Theme.backgroundColor.ignoresSafeArea()

                ScrollView {
                    VStack(spacing: 24) {
                        // Header removed for cleaner UI
                        // headerSection

                        // Feature Summary
                        Text("Analyze the internal structure, roots, and patterns of Arabic words to understand their derivation and nuances.")
                            .font(Theme.bodyFont)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 8)

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
            .navigationTitle("Morphology Analysis")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isTextFieldFocused = false
                    }
                    .foregroundColor(Theme.primaryColor)
                    .fontWeight(.semibold)
                }
            }
    }

    // MARK: - Header Section (Removed)
    // private var headerSection: some View { ... }

    // MARK: - Info Box (Removed)
    // private var infoBox: some View { ... }

    // MARK: - Search Form
    private var searchForm: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 10) {
                Label {
                    Text("Arabic Word")
                        .font(Theme.bodyFont)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "character.cursor.ibeam")
                        .foregroundColor(Theme.primaryColor)
                }

                TextField("Example: رددنا", text: $viewModel.searchWord)
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
                title: "Analyze",
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
                Text("Analysis Results")
                    .font(Theme.headingFont)
                    .foregroundColor(Theme.secondaryColor)
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if viewModel.morphologyResults.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.5))
                    Text("No results found")
                        .font(Theme.bodyFont)
                        .foregroundColor(.gray)
                }
                .frame(maxWidth: .infinity)
                .padding(40)
                .background(Color.white)
                .cornerRadius(12)
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
            .padding(20)
            .background(
                LinearGradient(
                    colors: [Theme.primaryColor.opacity(0.1), Theme.primaryColor.opacity(0.05)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            .cornerRadius(10)

            Divider()

            // Morphology Details
            VStack(spacing: 12) {
                morphologyRow(
                    icon: "text.book.closed",
                    label: "Meaning",
                    value: word.niceGloss ?? word.gloss,
                    isArabic: false
                )

                Divider()

                morphologyRow(
                    icon: "tag.fill",
                    label: "Part of Speech",
                    value: word.posNice,
                    isArabic: false
                )

                Divider()

                morphologyRow(
                    icon: "leaf.fill",
                    label: "Root",
                    value: word.root,
                    isArabic: true
                )

                if let measure = word.measure, !measure.isEmpty {
                    Divider()
                    morphologyRow(
                        icon: "scalemass.fill",
                        label: "Measure",
                        value: measure,
                        isArabic: false
                    )
                }
            }
        }
        .padding(24) // Increased padding for spacious look
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
    }
}

#Preview {
    SarfView()
}
