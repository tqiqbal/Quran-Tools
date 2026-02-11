//
//  About.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 28/11/2025.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.openURL) var openURL
    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    private var isIPad: Bool {
        horizontalSizeClass == .regular
    }

    var body: some View {
        ScrollView {
            VStack(spacing: isIPad ? 28 : 24) {
                // Header Section
                VStack(spacing: 12) {
                    Image(systemName: "book.pages.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Theme.primaryGradient)
                        .padding(.top, 20)

                    Text("About Quran Grammar")
                        .font(Theme.titleFont)
                        .foregroundColor(Theme.primaryColor)
                        .multilineTextAlignment(.center)

                    Text("Learn Arabic grammar through Quranic text analysis and morphology")
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.bottom, 8)

                // iPad: Use Grid Layout, iPhone: Stack Layout
                if isIPad {
                    // Two-column grid for iPad
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        featureCard
                        dataSourcesCard
                        privacyCard
                        disclaimerCard
                        copyrightCard
                        Color.clear.frame(height: 1) // Placeholder for odd number of items
                    }
                } else {
                    // Single column for iPhone
                    featureCard
                    dataSourcesCard
                    privacyCard
                    disclaimerCard
                    copyrightCard
                }

                // Contact & Suggestions
                VStack(spacing: 12) {
                    Text("Contact & Suggestions")
                        .font(Theme.headingFont)
                        .foregroundColor(Theme.primaryColor)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 8) {
                        Image(systemName: "envelope")
                            .foregroundColor(Theme.primaryColor)
                        Text("tanveer.iqbal92@gmail.com")
                            .font(Theme.bodyFont)
                            .foregroundColor(Theme.textColor)
                            .textSelection(.enabled)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 4)

                    Button(action: {
                        if let url = URL(string: "mailto:tanveer.iqbal92@gmail.com") {
                            openURL(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 18))
                            Text("tanveer.iqbal92@gmail.com")
                                .font(Theme.bodyFont)
                        }
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Theme.primaryGradient)
                        .cornerRadius(12)
                    }
                }
                .padding(.horizontal)
                .padding(.top, 8)

                // Version Footer
                Text("Version 1.0.0")
                    .font(Theme.smallFont)
                    .foregroundColor(Theme.textTertiary)
                    .padding(.top, 8)
                    .padding(.bottom, 20)
            }
            .padding(.horizontal, isIPad ? 32 : 16)
        }
        .background(Theme.backgroundColor)
    }

    // MARK: - Card Views
    private var featureCard: some View {
        SectionCard(
            icon: "star.fill",
            iconColor: Theme.accentAmber,
            title: "Features"
        ) {
            FeatureRow(icon: "text.magnifyingglass", text: "E'arab Analysis: Detailed grammatical breakdown of Quranic verses with English and Urdu translations")
            FeatureRow(icon: "character.book.closed", text: "Sarf Analysis: Morphological analysis of Arabic words including root derivation and grammatical forms")
            FeatureRow(icon: Theme.isIPad ? "ipad" : "iphone", text: "Optimized for iPhone & iPad")
            FeatureRow(icon: "lock.shield.fill", text: "Privacy First: Pure client-side application with zero data collection")
        }
    }

    private var dataSourcesCard: some View {
        SectionCard(
            icon: "server.rack",
            iconColor: Theme.primaryColor,
            title: "Data Sources"
        ) {
            Text("This application fetches data from the following trusted sources:")
                .font(Theme.smallFont)
                .foregroundColor(Theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)

            DataSourceRow(name: "E'arab (Grammatical Analysis)", description: "")
            DataSourceRow(name: "Surah Quran - surahquran.com", description: "Provides detailed Arabic grammatical analysis (E'arab) for Quranic verses")
            DataSourceRow(name: "Quran API - quranapi.pages.dev", description: "Supplies English and Urdu translations of Quranic verses")
            DataSourceRow(name: "Sarf (Morphology Analysis)", description: "")
            DataSourceRow(name: "AraTools - aratools.com", description: "Provides Arabic morphological analysis including root, form, and grammatical details")
        }
    }

    private var privacyCard: some View {
        SectionCard(
            icon: "hand.raised.fill",
            iconColor: Theme.successColor,
            title: "Privacy & Data"
        ) {
            Text("This application runs on your device and does not collect, store, or transmit any personal data. All requests are made directly to third-party APIs from your device.")
                .font(Theme.bodyFont)
                .foregroundColor(Theme.textColor)
                .fixedSize(horizontal: false, vertical: true)

            Text("Please refer to the privacy policies of the source websites for information about how they handle requests.")
                .font(Theme.smallFont)
                .foregroundColor(Theme.textSecondary)
                .padding(.top, 8)
        }
    }

    private var disclaimerCard: some View {
        SectionCard(
            icon: "info.circle.fill",
            iconColor: Theme.accentColor,
            title: "Disclaimer"
        ) {
            Text("This is an educational web application designed to help students learn Arabic grammar through Quranic text analysis. All content is fetched from third-party sources and we do not claim ownership of any religious texts or grammatical analyses.")
                .font(Theme.bodyFont)
                .foregroundColor(Theme.textColor)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var copyrightCard: some View {
        SectionCard(
            icon: "c.circle.fill",
            iconColor: Theme.textSecondary,
            title: "Copyright & Attribution"
        ) {
            Text("All rights reserved to original sources. This application serves as an educational interface and does not claim ownership of any content provided by the third-party sources mentioned above.")
                .font(Theme.bodyFont)
                .foregroundColor(Theme.textColor)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

// MARK: - Section Card Component
struct SectionCard<Content: View>: View {
    let icon: String
    let iconColor: Color
    let title: String
    let content: Content

    init(icon: String, iconColor: Color, title: String, @ViewBuilder content: () -> Content) {
        self.icon = icon
        self.iconColor = iconColor
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(iconColor)

                Text(title)
                    .font(Theme.headingFont)
                    .foregroundColor(Theme.textColor)

                Spacer()
            }

            content
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackground)
        .cornerRadius(16)
        .shadow(color: Theme.cardShadow(), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Feature Row Component
struct FeatureRow: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(Theme.primaryColor)
                .frame(width: 20)

            Text(text)
                .font(Theme.bodyFont)
                .foregroundColor(Theme.textColor)
                .fixedSize(horizontal: false, vertical: true)

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Data Source Row Component
struct DataSourceRow: View {
    let name: String
    let description: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(Theme.bodyFont)
                .fontWeight(.semibold)
                .foregroundColor(Theme.primaryColor)

            Text(description)
                .font(Theme.smallFont)
                .foregroundColor(Theme.textSecondary)
        }
        .padding(.vertical, 6)
    }
}

#Preview {
    AboutView()
}
