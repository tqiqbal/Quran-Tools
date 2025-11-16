//
//  StyledComponents.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import SwiftUI

// MARK: - Info Banner
struct InfoBanner: View {
    let title: String
    let message: String

    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                Circle()
                    .fill(Theme.primaryGradient)
                    .frame(width: 44, height: 44)

                Image(systemName: "info.circle.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 20, weight: .semibold))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Theme.bodyFont)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textColor)

                Text(message)
                    .font(Theme.smallFont)
                    .foregroundColor(Theme.textSecondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Theme.cardBackground)

                RoundedRectangle(cornerRadius: 16)
                    .fill(
                        LinearGradient(
                            colors: [
                                Theme.primaryColor.opacity(0.05),
                                Theme.primaryLight.opacity(0.02)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(
                    LinearGradient(
                        colors: [Theme.primaryColor.opacity(0.2), Theme.primaryLight.opacity(0.1)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1
                )
        )
        .shadow(color: Theme.softShadow(), radius: 12, x: 0, y: 4)
    }
}

// MARK: - Gradient Button
struct GradientButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.9)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 16, weight: .semibold))
                }

                Text(title)
                    .font(Theme.bodyFont)
                    .fontWeight(.bold)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .padding(.horizontal, 24)
            .background(
                Group {
                    if isDisabled {
                        LinearGradient(
                            colors: [Color.gray.opacity(0.4), Color.gray.opacity(0.3)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    } else {
                        Theme.primaryGradient
                    }
                }
            )
            .foregroundColor(.white)
            .cornerRadius(14)
            .shadow(
                color: isDisabled ? .clear : Theme.softShadow(),
                radius: 16,
                x: 0,
                y: 8
            )
        }
        .disabled(isDisabled || isLoading)
    }
}

// MARK: - Section Header
struct SectionHeader: View {
    let icon: String
    let title: String
    var color: Color = Theme.primaryColor

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(
                    LinearGradient(
                        colors: [color, color.opacity(0.7)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            Text(title)
                .font(Theme.headingFont)
                .foregroundColor(Theme.textColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Enhanced TextField
struct StyledTextField: View {
    let icon: String
    let label: String
    let placeholder: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    @FocusState.Binding var isFocused: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label {
                Text(label)
                    .font(Theme.bodyFont)
                    .fontWeight(.semibold)
                    .foregroundColor(Theme.textColor)
            } icon: {
                Image(systemName: icon)
                    .foregroundColor(Theme.primaryColor)
                    .font(.system(size: 16, weight: .semibold))
            }

            TextField(placeholder, text: $text)
                .font(Theme.bodyFont)
                .padding(14)
                .background(Theme.cardBackground)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            isFocused ?
                                LinearGradient(
                                    colors: [Theme.primaryColor, Theme.primaryLight],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ) :
                                LinearGradient(
                                    colors: [Color.gray.opacity(0.2), Color.gray.opacity(0.15)],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                            lineWidth: isFocused ? 2 : 1
                        )
                )
                .keyboardType(keyboardType)
                .focused($isFocused)
        }
    }
}
