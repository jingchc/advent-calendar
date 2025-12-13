//
//  DemoApp.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import SwiftData
import Dependencies

@main
struct DemoApp: App {
    @Dependency(\.database) var database

    init() {
        database.seedIfNeeded()
    }

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light)
        }
        .modelContainer(database.container)
    }
}
