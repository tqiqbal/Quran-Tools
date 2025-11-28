//
//  ContentView.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import SwiftUI

struct ContentView: View {
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
        TabView {
            EarabView()
                .tabItem {
                    Label("إعراب", systemImage: "book.fill")
                }

            SarfView()
                .tabItem {
                    Label("صرف", systemImage: "character.book.closed.fill")
                }

            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle.fill")
                }
        }
        .accentColor(Theme.primaryColor)
    }
}

#Preview {
    ContentView()
}
