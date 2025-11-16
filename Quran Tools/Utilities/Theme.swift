//
//  Theme.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import SwiftUI

struct Theme {
    // Fresh Green/Teal Color Palette
    static let primaryColor = Color(hex: "10B981")        // Emerald
    static let primaryLight = Color(hex: "34D399")        // Light Emerald
    static let primaryDark = Color(hex: "059669")         // Deep Emerald

    static let secondaryColor = Color(hex: "0F172A")      // Slate 900
    static let secondaryLight = Color(hex: "475569")      // Slate 600

    static let accentColor = Color(hex: "14B8A6")         // Teal
    static let accentGreen = Color(hex: "22C55E")         // Green
    static let accentAmber = Color(hex: "F59E0B")         // Amber

    static let backgroundColor = Color(hex: "F0FDF4")     // Green 50
    static let cardBackground = Color.white
    static let surfaceColor = Color(hex: "DCFCE7")        // Green 100

    static let errorColor = Color(hex: "EF4444")          // Red 500
    static let successColor = Color(hex: "10B981")        // Emerald 500
    static let warningColor = Color(hex: "F59E0B")        // Amber 500

    static let textColor = Color(hex: "1E293B")           // Slate 800
    static let textSecondary = Color(hex: "64748B")       // Slate 500
    static let textTertiary = Color(hex: "94A3B8")        // Slate 400

    // Typography
    static let titleFont = Font.system(size: 28, weight: .bold)
    static let headingFont = Font.system(size: 20, weight: .semibold)
    static let bodyFont = Font.system(size: 16, weight: .regular)
    static let arabicFont = Font.system(size: 20, weight: .medium)
    static let arabicLargeFont = Font.system(size: 24, weight: .semibold)
    static let earabContentFont = Font.system(size: 17, weight: .regular)
    static let smallFont = Font.system(size: 14, weight: .regular)

    // Gradients
    static let primaryGradient = LinearGradient(
        colors: [primaryColor, primaryLight],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let softGradient = LinearGradient(
        colors: [Color(hex: "F8FAFC"), Color(hex: "E2E8F0")],
        startPoint: .top,
        endPoint: .bottom
    )

    static let accentGradient = LinearGradient(
        colors: [Color(hex: "10B981"), Color(hex: "14B8A6")],
        startPoint: .leading,
        endPoint: .trailing
    )

    // Shadows
    static func cardShadow(opacity: Double = 0.08) -> Color {
        Color.black.opacity(opacity)
    }

    static func softShadow() -> Color {
        Color(hex: "10B981").opacity(0.15)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
