//
//  ContentView.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @State private var selectedTab: Tab = .earab
    @State private var showSidebar = true

    enum Tab {
        case earab, sarf, about
    }

    init() {
        // Customize TabBar appearance for modern look
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor(Theme.cardBackground)

        // Shadow for depth
        appearance.shadowColor = UIColor(Theme.cardShadow(opacity: 0.1))

        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    var body: some View {
        // Use different layouts for iPhone and iPad
        if horizontalSizeClass == .regular {
            // iPad Layout - Sidebar Navigation
            iPadLayout
        } else {
            // iPhone Layout - Tab Bar
            iPhoneLayout
        }
    }

    // MARK: - iPhone Layout
    private var iPhoneLayout: some View {
        TabView(selection: $selectedTab) {
            EarabView()
                .tabItem {
                    Label("Analysis", systemImage: "book.fill")
                }
                .tag(Tab.earab)

            SarfView()
                .tabItem {
                    Label("Morphology", systemImage: "character.book.closed.fill")
                }
                .tag(Tab.sarf)

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle.fill")
                }
                .tag(Tab.about)
        }
        .accentColor(Theme.primaryColor)
    }

    // MARK: - iPad Layout
    private var iPadLayout: some View {
        ZStack(alignment: .leading) {
            // Main Content - All views in ZStack to preserve state
            ZStack {
                EarabView()
                    .opacity(selectedTab == .earab ? 1 : 0)
                    .zIndex(selectedTab == .earab ? 1 : 0)

                SarfView()
                    .opacity(selectedTab == .sarf ? 1 : 0)
                    .zIndex(selectedTab == .sarf ? 1 : 0)

                AboutView()
                    .opacity(selectedTab == .about ? 1 : 0)
                    .zIndex(selectedTab == .about ? 1 : 0)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.leading, showSidebar ? 280 : 0)

            // Sidebar
            if showSidebar {
                VStack(spacing: 0) {
                    // Header with close button
                    HStack {
                        VStack(spacing: 12) {
                            Image(systemName: "book.pages.fill")
                                .font(.system(size: 40))
                                .foregroundStyle(Theme.primaryGradient)

                            Text("Quran Tools")
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(Theme.primaryColor)

                            Text("E'arab & Sarf")
                                .font(.system(size: 14))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .frame(maxWidth: .infinity)

                        Spacer()

                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                showSidebar = false
                            }
                        }) {
                            Image(systemName: "sidebar.left")
                                .font(.system(size: 20))
                                .foregroundColor(Theme.primaryColor)
                                .padding(8)
                                .background(Theme.primaryColor.opacity(0.1))
                                .cornerRadius(8)
                        }
                        .padding(.trailing, 12)
                    }
                    .padding(.vertical, 20)
                    .padding(.top, 20)

                    // Navigation Items
                    VStack(spacing: 8) {
                        SidebarButton(
                            title: "Quran Analysis",
                            subtitle: "Grammar & Syntax",
                            icon: "book.fill",
                            iconColor: Theme.primaryColor,
                            isSelected: selectedTab == .earab
                        ) {
                            selectedTab = .earab
                        }

                        SidebarButton(
                            title: "Morphology",
                            subtitle: "Word Analysis",
                            icon: "character.book.closed.fill",
                            iconColor: Theme.accentColor,
                            isSelected: selectedTab == .sarf
                        ) {
                            selectedTab = .sarf
                        }

                        SidebarButton(
                            title: "About",
                            subtitle: "App Info",
                            icon: "info.circle.fill",
                            iconColor: Theme.accentGreen,
                            isSelected: selectedTab == .about
                        ) {
                            selectedTab = .about
                        }
                    }
                    .padding(.horizontal, 12)
                    .padding(.top, 20)

                    Spacer()
                }
                .frame(width: 280)
                .background(Theme.cardBackground)
                .shadow(color: Theme.cardShadow(opacity: 0.1), radius: 8, x: 2, y: 0)
                .transition(.move(edge: .leading))
            }

            // Floating button to open sidebar when closed
            if !showSidebar {
                VStack {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            showSidebar = true
                        }
                    }) {
                        Image(systemName: "sidebar.left")
                            .font(.system(size: 22))
                            .foregroundColor(.white)
                            .padding(16)
                            .background(
                                Circle()
                                    .fill(Theme.primaryGradient)
                                    .shadow(color: Theme.primaryColor.opacity(0.4), radius: 12, x: 0, y: 4)
                            )
                    }
                    .padding(.top, 20)
                    .padding(.leading, 20)

                    Spacer()
                }
                .transition(.move(edge: .leading).combined(with: .opacity))
            }
        }
        .accentColor(Theme.primaryColor)
    }
}

// MARK: - Sidebar Button Component
struct SidebarButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let iconColor: Color
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .foregroundColor(isSelected ? .white : iconColor)
                    .font(.system(size: 20))
                    .frame(width: 32)

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(isSelected ? .white : Theme.textColor)
                        .environment(\.layoutDirection, title.contains("ا") ? .rightToLeft : .leftToRight)

                    Text(subtitle)
                        .font(.system(size: 12))
                        .foregroundColor(isSelected ? .white.opacity(0.9) : Theme.textSecondary)
                }

                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(isSelected ? Theme.primaryColor : Color.clear)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    ContentView()
}
