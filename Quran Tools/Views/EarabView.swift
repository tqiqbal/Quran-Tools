//
//  EarabView.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import SwiftUI

struct EarabView: View {
    @StateObject private var viewModel = EarabViewModel()
    @FocusState private var isAyahFieldFocused: Bool
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
                        Text("Understand the grammatical structure and syntax of Quranic verses to gain deeper insights into their meaning.")
                            .font(Theme.bodyFont)
                            .foregroundColor(Theme.textSecondary)
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.bottom, 8)

                        // Form Section
                        formSection

                        // Error Message
                        if let error = viewModel.errorMessage {
                            errorView(message: error)
                        }

                        // Results Section
                        if viewModel.showResults {
                            resultsSection
                        }
                    }
                    .padding()
                }
                .onTapGesture {
                    isAyahFieldFocused = false
                }
            }
            .navigationTitle("Quran Analysis")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        isAyahFieldFocused = false
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

    // MARK: - Form Section
    private var formSection: some View {
        VStack(spacing: 20) {
            // Surah Picker
            VStack(alignment: .leading, spacing: 10) {
                Label {
                    Text("Select Surah")
                        .font(Theme.bodyFont)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "book.closed.fill")
                        .foregroundColor(Theme.primaryColor)
                }

                if viewModel.surahs.isEmpty {
                    HStack {
                        ProgressView()
                        Text("Loading Surahs...")
                            .font(Theme.bodyFont)
                            .foregroundColor(.gray)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                } else {
                    Menu {
                        Picker("Surah", selection: $viewModel.selectedSurah) {
                            Text("Select a Surah").tag(nil as Surah?)
                            ForEach(viewModel.surahs) { surah in
                                Text("\(surah.number). \(surah.name) - \(surah.englishName)")
                                    .tag(surah as Surah?)
                            }
                        }
                    } label: {
                        HStack {
                            if let surah = viewModel.selectedSurah {
                                Text("\(surah.number). \(surah.name) - \(surah.englishName)")
                                    .foregroundColor(Theme.textColor)
                            } else {
                                Text("Select a Surah")
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(Theme.primaryColor)
                        }
                        .font(Theme.bodyFont)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Theme.primaryColor.opacity(0.3), lineWidth: 1)
                        )
                    }
                    .onChange(of: viewModel.selectedSurah) { _ in
                        viewModel.currentAyah = 1
                    }
                }
            }

            // Ayah Input
            VStack(alignment: .leading, spacing: 10) {
                Label {
                    Text("Ayah Number")
                        .font(Theme.bodyFont)
                        .fontWeight(.semibold)
                } icon: {
                    Image(systemName: "number")
                        .foregroundColor(Theme.primaryColor)
                }

                TextField("1", value: $viewModel.currentAyah, format: .number)
                    .keyboardType(.numberPad)
                    .font(Theme.headingFont)
                    .multilineTextAlignment(.center)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(
                                isAyahFieldFocused ? Theme.primaryColor : Theme.primaryColor.opacity(0.3),
                                lineWidth: isAyahFieldFocused ? 2 : 1
                            )
                    )
                    .focused($isAyahFieldFocused)
                    .disabled(viewModel.selectedSurah == nil)

                if let surah = viewModel.selectedSurah {
                    Text("From 1 to \(surah.numberOfAyahs)")
                        .font(Theme.smallFont)
                        .foregroundColor(.gray)
                }
            }

            // Submit Button
            GradientButton(
                title: "Analyze",
                icon: "arrow.right.circle.fill",
                action: {
                    isAyahFieldFocused = false
                    Task {
                        await viewModel.fetchEarab()
                    }
                },
                isLoading: viewModel.isLoading,
                isDisabled: viewModel.selectedSurah == nil
            )
        }
        .padding(20)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.08), radius: 8, x: 0, y: 2)
    }

    // MARK: - Results Section
    private var resultsSection: some View {
        VStack(spacing: 20) {
            // Navigation Buttons
            navigationButtons

            // E'arab Content
            if !viewModel.earabTitle.isEmpty || !viewModel.earabCards.isEmpty {
                earabContentView
            }

            // Source Link
//            sourceLinkButton
        }
    }

    // MARK: - Navigation Buttons
    private var navigationButtons: some View {
        HStack(spacing: 12) {
            Button(action: {
                viewModel.navigateAyah(direction: -1)
            }) {
                HStack(spacing: 8) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 14, weight: .bold))
                    Text("Previous")
                        .font(Theme.bodyFont)
                        .fontWeight(.semibold)
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(viewModel.canNavigatePrevious() ? Theme.primaryColor : Color.gray.opacity(0.3))
                .foregroundColor(viewModel.canNavigatePrevious() ? .white : .gray)
                .cornerRadius(10)
            }
            .disabled(!viewModel.canNavigatePrevious())

            Button(action: {
                viewModel.navigateAyah(direction: 1)
            }) {
                HStack(spacing: 8) {
                    Text("Next")
                        .font(Theme.bodyFont)
                        .fontWeight(.semibold)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .bold))
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity)
                .background(viewModel.canNavigateNext() ? Theme.primaryColor : Color.gray.opacity(0.3))
                .foregroundColor(viewModel.canNavigateNext() ? .white : .gray)
                .cornerRadius(10)
            }
            .disabled(!viewModel.canNavigateNext())
        }
    }

    // MARK: - E'arab Content View
    private var earabContentView: some View {
        VStack(alignment: .leading, spacing: 16) {
            if !viewModel.earabTitle.isEmpty {
                HStack {
                    Image(systemName: "text.book.closed.fill")
                        .foregroundColor(Theme.primaryColor)
                    Text(viewModel.earabTitle)
                        .font(Theme.headingFont)
                        .foregroundColor(Theme.secondaryColor)
                }
            }

            ForEach(Array(viewModel.earabCards.enumerated()), id: \.offset) { _, card in
                VStack(alignment: .leading, spacing: 12) {
                    Text(card)
                        .font(Theme.earabContentFont)
                        .lineSpacing(10) // Increased line spacing for readability
                        .foregroundColor(Theme.textColor)
                        .environment(\.layoutDirection, .rightToLeft) // Keep Arabic text RTL
                }
                .padding(16) // Reduced inner padding to maximize text width
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
                .overlay(
                    Rectangle()
                        .fill(Theme.primaryColor)
                        .frame(width: 4)
                        .cornerRadius(2),
                    alignment: .leading
                )
            }
        }
        .padding(12) // Reduced outer padding
        .background(
            LinearGradient(
                colors: [Color.gray.opacity(0.05), Color.gray.opacity(0.02)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(16)
    }

    // MARK: - Source Link Button
    private var sourceLinkButton: some View {
        Button(action: {
            if let url = viewModel.getSourceURL() {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                Image(systemName: "link.circle.fill")
                Text("View Original Source")
                    .fontWeight(.medium)
            }
            .font(Theme.bodyFont)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Theme.secondaryColor)
            .foregroundColor(.white)
            .cornerRadius(12)
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
    EarabView()
}
