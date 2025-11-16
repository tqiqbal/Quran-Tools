//
//  ContentView.swift
//  Quran Tools
//
//  Created by Tanveer Iqbal on 16/11/2025.
//

import SwiftUI

struct ContentView: View {
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
        }
        .accentColor(Theme.primaryColor)
    }
}

#Preview {
    ContentView()
}
