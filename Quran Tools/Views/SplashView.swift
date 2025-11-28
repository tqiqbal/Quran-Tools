//
//  SplashView.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 28/11/2025.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var rotationAngle: Double = 0

    var body: some View {
        ZStack {
            // Background Gradient
            LinearGradient(
                colors: [
                    Theme.primaryColor.opacity(0.1),
                    Theme.backgroundColor,
                    Theme.primaryLight.opacity(0.15)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 32) {
                Spacer()

                // App Icon/Logo Area
                ZStack {
                    // Outer rotating circle
                    Circle()
                        .stroke(
                            LinearGradient(
                                colors: [Theme.primaryColor.opacity(0.3), Theme.accentColor.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 3
                        )
                        .frame(width: 140, height: 140)
                        .rotationEffect(.degrees(rotationAngle))

                    // Inner circle
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Theme.primaryColor.opacity(0.2), Theme.primaryLight.opacity(0.1)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 120, height: 120)

                    // Icon
                    Image(systemName: "book.pages.fill")
                        .font(.system(size: 50, weight: .semibold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Theme.primaryColor, Theme.accentColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .scaleEffect(isAnimating ? 1.0 : 0.6)
                        .opacity(isAnimating ? 1.0 : 0.3)
                }
                .shadow(color: Theme.primaryColor.opacity(0.2), radius: 20, x: 0, y: 10)

                // App Name
                VStack(spacing: 12) {
                    Text("Quran Tools")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Theme.primaryColor, Theme.accentColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .opacity(isAnimating ? 1.0 : 0)
                        .offset(y: isAnimating ? 0 : 20)

                    // Arabic Names
                    HStack(spacing: 8) {
                        Text("إعراب")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Theme.primaryColor)

                        Circle()
                            .fill(Theme.primaryColor)
                            .frame(width: 4, height: 4)

                        Text("صرف")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(Theme.primaryColor)
                    }
                    .opacity(isAnimating ? 1.0 : 0)
                    .offset(y: isAnimating ? 0 : 20)
                    .environment(\.layoutDirection, .rightToLeft)

                    Text("E'arab & Sarf")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(Theme.textSecondary)
                        .opacity(isAnimating ? 1.0 : 0)
                        .offset(y: isAnimating ? 0 : 20)
                }

                Spacer()

                // Loading Indicator
                VStack(spacing: 16) {
                    // Custom Loading Animation
                    HStack(spacing: 8) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Theme.primaryColor)
                                .frame(width: 10, height: 10)
                                .scaleEffect(isAnimating ? 1.0 : 0.5)
                                .opacity(isAnimating ? 1.0 : 0.3)
                                .animation(
                                    .easeInOut(duration: 0.6)
                                    .repeatForever()
                                    .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }

                    Text("Loading...")
                        .font(Theme.smallFont)
                        .foregroundColor(Theme.textSecondary)
                        .opacity(isAnimating ? 0.7 : 0)
                }
                .padding(.bottom, 50)
            }
            .padding()
        }
        .onAppear {
            // Start animations
            withAnimation(.easeOut(duration: 1.0)) {
                isAnimating = true
            }

            // Continuous rotation for outer circle
            withAnimation(.linear(duration: 3.0).repeatForever(autoreverses: false)) {
                rotationAngle = 360
            }
        }
    }
}

#Preview {
    SplashView()
}
