//
//  MainTabView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import SwiftData

struct MainTabView: View {
    init() {
        // Tab Bar
        let tabAppearance = UITabBarAppearance()
        tabAppearance.configureWithOpaqueBackground()

        let itemAppearance = UITabBarItemAppearance()
        let tabFont = UIFont.appFont(size: 10)
        itemAppearance.normal.titleTextAttributes = [.font: tabFont]
        itemAppearance.selected.titleTextAttributes = [.font: tabFont]

        tabAppearance.stackedLayoutAppearance = itemAppearance
        tabAppearance.inlineLayoutAppearance = itemAppearance
        tabAppearance.compactInlineLayoutAppearance = itemAppearance
        
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance
        
        // Navigation Bar - only change font
        let navAppearance = UINavigationBarAppearance()
        navAppearance.titleTextAttributes = [.font: UIFont.appFont(size: 17)]
        navAppearance.largeTitleTextAttributes = [.font: UIFont.appFont(size: 34)]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
    }

    var body: some View {
        TabView {
            AdventCalendarView()
                .tabItem {
                    Label("Calendar", systemImage: "calendar")
                }

            NavigationStack {
                FavoritesView()
            }
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
        }
        .tint(.christmasRed)
    }
}

#Preview {
    MainTabView()
        .modelContainer(for: AdventDay.self, inMemory: true)
}
