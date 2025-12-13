//
//  MainTabView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import SwiftData
import Dependencies

struct MainTabView: View {
    @Dependency(\.router) var router

    init() {
        // Tab Bar
        let tabAppearance = UITabBarAppearance()
        let itemAppearance = UITabBarItemAppearance()
        let tabFont = UIFont.appFont(size: 10)
        itemAppearance.normal.titleTextAttributes = [.font: tabFont]
        itemAppearance.selected.titleTextAttributes = [.font: tabFont]
        tabAppearance.stackedLayoutAppearance = itemAppearance
        tabAppearance.inlineLayoutAppearance = itemAppearance
        tabAppearance.compactInlineLayoutAppearance = itemAppearance
        UITabBar.appearance().standardAppearance = tabAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabAppearance

        // Navigation Bar
        let navAppearance = UINavigationBarAppearance()
        navAppearance.titleTextAttributes = [.font: UIFont.appFont(size: 17)]
        navAppearance.largeTitleTextAttributes = [.font: UIFont.appFont(size: 34)]
        UINavigationBar.appearance().standardAppearance = navAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        UINavigationBar.appearance().compactAppearance = navAppearance
    }

    var body: some View {
        @Bindable var router = router

        TabView {
            NavigationStack(path: $router.calendarPath) {
                AdventCalendarView()
                    .navigationDestination(for: Destination.self) { destination in
                        switch destination {
                        case .video(let day):
                            VideoPlayerView(day: day)
                        }
                    }
            }
            .toolbar(router.calendarPath.isEmpty ? .visible : .hidden, for: .tabBar)
            .tabItem {
                Label("Calendar", systemImage: "calendar")
            }

            NavigationStack(path: $router.favoritesPath) {
                FavoritesView()
                    .navigationDestination(for: Destination.self) { destination in
                        switch destination {
                        case .video(let day):
                            VideoPlayerView(day: day)
                        }
                    }
            }
            .toolbar(router.favoritesPath.isEmpty ? .visible : .hidden, for: .tabBar)
            .tabItem {
                Label("Favorites", systemImage: "heart.fill")
            }
        }
    }
}

#Preview {
    @Dependency(\.database) var database
    MainTabView()
        .modelContainer(database.container)
}
