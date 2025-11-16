//
//  CardView.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import SwiftUI

struct CardView<Content: View>: View {
    let content: Content
    var borderColor: Color = Theme.primaryColor
    var showBorder: Bool = true

    init(borderColor: Color = Theme.primaryColor, showBorder: Bool = true, @ViewBuilder content: () -> Content) {
        self.borderColor = borderColor
        self.showBorder = showBorder
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            content
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Theme.cardBackground)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor.opacity(0.1), lineWidth: 1)
        )
        .overlay(
            Group {
                if showBorder {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(
                            LinearGradient(
                                colors: [borderColor, borderColor.opacity(0.6)],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: 5)
                        .offset(x: -0.5)
                }
            },
            alignment: .leading
        )
        .shadow(color: Theme.cardShadow(opacity: 0.04), radius: 8, x: 0, y: 2)
        .shadow(color: Theme.cardShadow(opacity: 0.03), radius: 16, x: 0, y: 4)
    }
}

struct LoadingView: View {
    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.5)
            Text("جاري التحميل...")
                .font(Theme.bodyFont)
                .foregroundColor(Theme.secondaryColor)
        }
        .frame(maxWidth: .infinity)
        .padding(40)
    }
}

struct PrimaryButton: View {
    let title: String
    let action: () -> Void
    var isLoading: Bool = false
    var isDisabled: Bool = false

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
                Text(title)
                    .font(Theme.bodyFont)
                    .fontWeight(.semibold)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(isDisabled ? Color.gray : Theme.primaryColor)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .disabled(isDisabled || isLoading)
    }
}
