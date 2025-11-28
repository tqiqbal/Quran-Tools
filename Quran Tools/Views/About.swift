//
//  About.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 28/11/2025.
//

import SwiftUI

struct AboutView: View {
    @Environment(\.openURL) var openURL

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header Section
                VStack(spacing: 12) {
                    Image(systemName: "book.pages.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(Theme.primaryGradient)
                        .padding(.top, 20)

                    Text("Quran E'arab & Sarf")
                        .font(Theme.titleFont)
                        .foregroundColor(Theme.primaryColor)
                        .multilineTextAlignment(.center)

                    Text("Educational tool for learning Arabic grammar through Quranic text analysis")
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.bottom, 8)

                // Features Section
                SectionCard(
                    icon: "star.fill",
                    iconColor: Theme.accentAmber,
                    title: "Features"
                ) {
                    FeatureRow(icon: "text.magnifyingglass", text: "Detailed grammatical breakdowns of Quranic verses")
                    FeatureRow(icon: "character.book.closed", text: "Morphological word analysis with roots and forms")
                    FeatureRow(icon: "iphone", text: "Mobile-optimized for iOS devices")
                    FeatureRow(icon: "lock.shield.fill", text: "Runs entirely on your device - no data transmission")
                }

                // Data Sources Section
                SectionCard(
                    icon: "server.rack",
                    iconColor: Theme.primaryColor,
                    title: "Data Sources"
                ) {
                    DataSourceRow(name: "Surah Quran", description: "Grammatical analysis of Quranic verses")
                    DataSourceRow(name: "Quran API", description: "English and Urdu translations")
                    DataSourceRow(name: "AraTools", description: "Morphological analysis with roots and forms")
                }

                // Privacy Section
                SectionCard(
                    icon: "hand.raised.fill",
                    iconColor: Theme.successColor,
                    title: "Privacy & Data"
                ) {
                    Text("This application runs entirely in your browser and does not collect, store, or transmit any personal data.")
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textColor)
                        .fixedSize(horizontal: false, vertical: true)

                    Text("Please review third-party privacy policies for their data handling practices.")
                        .font(Theme.smallFont)
                        .foregroundColor(Theme.textSecondary)
                        .padding(.top, 8)
                }

                // Disclaimer Section
                SectionCard(
                    icon: "info.circle.fill",
                    iconColor: Theme.accentColor,
                    title: "Disclaimer"
                ) {
                    Text("This tool helps students study Arabic grammar using Quranic verses. Content originates from third-party sources, with no ownership claims over religious texts or grammatical materials.")
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textColor)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // Copyright Section
                SectionCard(
                    icon: "c.circle.fill",
                    iconColor: Theme.textSecondary,
                    title: "Copyright"
                ) {
                    Text("Rights remain with original sources. This application functions as an educational interface without claiming content ownership.")
                        .font(Theme.bodyFont)
                        .foregroundColor(Theme.textColor)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // Contact Section
                VStack(spacing: 12) {
                    Button(action: {
                        if let url = URL(string: "mailto:tanveer.iqbal92@gmail.com") {
                            openURL(url)
                        }
                    }) {
                        HStack {
                            Image(systemName: "envelope.fill")
                                .font(.system(size: 18))
                            Text("Contact: tanveer.iqbal92@gmail.com")
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
            .padding(.horizontal)
        }
        .background(Theme.backgroundColor)
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
