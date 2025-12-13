//
//  Router.swift
//  Demo
//
//  Created by JingChuang on 2025/12/13.
//

import SwiftUI
import Dependencies

enum Destination: Hashable {
    case video(AdventDay)
}

@Observable
class Router {
    var calendarPath = NavigationPath()
    var favoritesPath = NavigationPath()

    func push(_ destination: Destination, from tab: Tab) {
        switch tab {
        case .calendar:
            calendarPath.append(destination)
        case .favorites:
            favoritesPath.append(destination)
        }
    }

    func pop(from tab: Tab) {
        switch tab {
        case .calendar:
            if !calendarPath.isEmpty {
                calendarPath.removeLast()
            }
        case .favorites:
            if !favoritesPath.isEmpty {
                favoritesPath.removeLast()
            }
        }
    }

    func popToRoot(tab: Tab) {
        switch tab {
        case .calendar:
            calendarPath = NavigationPath()
        case .favorites:
            favoritesPath = NavigationPath()
        }
    }

    enum Tab {
        case calendar
        case favorites
    }
}

// MARK: - Dependency

extension Router: DependencyKey {
    static let liveValue = Router()
    static let previewValue = Router()
    static let testValue = Router()
}

extension DependencyValues {
    var router: Router {
        get { self[Router.self] }
        set { self[Router.self] = newValue }
    }
}
