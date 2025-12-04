//
//  SplashView.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 28/11/2025.
//

import SwiftUI

struct SplashView: View {
    @State private var isAnimating = false
    @State private var logoScale: CGFloat = 0.8
    @State private var logoOpacity: Double = 0
    @State private var titleOffset: CGFloat = 20
    @State private var titleOpacity: Double = 0
    @State private var subtitleOffset: CGFloat = 20
    @State private var subtitleOpacity: Double = 0
    
    var body: some View {
        ZStack {
            // Premium Background Gradient
            LinearGradient(
                colors: [
                    Theme.primaryColor.opacity(0.15),
                    Theme.backgroundColor,
                    Color.white,
                    Theme.primaryLight.opacity(0.1)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            // Decorative background elements
            GeometryReader { geometry in
                Circle()
                    .fill(Theme.primaryColor.opacity(0.05))
                    .frame(width: 300, height: 300)
                    .position(x: geometry.size.width * 0.8, y: geometry.size.height * 0.1)
                
                Circle()
                    .fill(Theme.accentColor.opacity(0.05))
                    .frame(width: 200, height: 200)
                    .position(x: geometry.size.width * 0.1, y: geometry.size.height * 0.8)
            }
            .ignoresSafeArea()

            VStack(spacing: 40) {
                Spacer()

                // Logo Section
                ZStack {
                    // Outer glow
                    Circle()
                        .fill(Theme.primaryColor.opacity(0.1))
                        .frame(width: 160, height: 160)
                        .scaleEffect(isAnimating ? 1.1 : 1.0)
                        .animation(
                            .easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: isAnimating
                        )
                    
                    // Main Icon Container
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Theme.primaryColor.opacity(0.1), Theme.primaryLight.opacity(0.05)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 140, height: 140)
                        .overlay(
                            Circle()
                                .stroke(
                                    LinearGradient(
                                        colors: [Theme.primaryColor.opacity(0.4), Theme.accentColor.opacity(0.2)],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    ),
                                    lineWidth: 1
                                )
                        )
                        .shadow(color: Theme.primaryColor.opacity(0.15), radius: 20, x: 0, y: 10)

                    // Icon
                    Image(systemName: "book.pages.fill")
                        .font(.system(size: 60))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Theme.primaryColor, Theme.accentColor],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                }
                .scaleEffect(logoScale)
                .opacity(logoOpacity)

                // Text Section
                VStack(spacing: 16) {
                    Text("Quran Tools")
                        .font(.system(size: 42, weight: .bold))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [Theme.secondaryColor, Theme.primaryColor],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .offset(y: titleOffset)
                        .opacity(titleOpacity)

                    VStack(spacing: 8) {
                        HStack(spacing: 12) {
                            Text("Analysis")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                            
                            Circle()
                                .fill(Theme.primaryColor.opacity(0.5))
                                .frame(width: 4, height: 4)
                            
                            Text("Morphology")
                                .font(.system(size: 18, weight: .medium))
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                    .offset(y: subtitleOffset)
                    .opacity(subtitleOpacity)
                }

                Spacer()

                // Elegant Loading Indicator
                HStack(spacing: 6) {
                    ForEach(0..<3) { index in
                        Circle()
                            .fill(Theme.primaryColor)
                            .frame(width: 8, height: 8)
                            .opacity(isAnimating ? 1 : 0.3)
                            .scaleEffect(isAnimating ? 1 : 0.8)
                            .animation(
                                .easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                                value: isAnimating
                            )
                    }
                }
                .padding(.bottom, 50)
                .opacity(subtitleOpacity) // Fade in with subtitle
            }
        }
        .onAppear {
            // Staggered Animation Sequence
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                logoScale = 1.0
                logoOpacity = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.3)) {
                titleOffset = 0
                titleOpacity = 1.0
            }
            
            withAnimation(.easeOut(duration: 0.8).delay(0.6)) {
                subtitleOffset = 0
                subtitleOpacity = 1.0
            }
            
            // Continuous animations
            isAnimating = true
        }
    }
}

#Preview {
    SplashView()
}
