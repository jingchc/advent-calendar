//
//  AccessibilityID.swift
//  Demo
//
//  Created by JingChuang on 2025/12/13.
//

import Foundation

enum AccessibilityID {
    // MARK: - Tab Bar
    enum TabBar {
        static let calendar = "Calendar"
        static let favorites = "Favorites"
    }

    // MARK: - Navigation Bar
    enum NavigationBar {
        static let adventCalendar = "Advent Calendar"
        static let favorites = "Favorites"
    }

    // MARK: - Calendar
    enum Calendar {
        static func dayCell(_ day: Int) -> String { "dayCell_\(day)" }
    }

    // MARK: - Favorites
    enum Favorites {
        static let emptyLabel = "No Favorites Yet"
    }

    // MARK: - Video Player
    enum VideoPlayer {
        static let container = "videoPlayer"
        static let playPauseButton = "playPauseButton"
        static let favoriteButton = "favoriteButton"
        static let toggleTitleButton = "toggleTitleButton"
    }
}
