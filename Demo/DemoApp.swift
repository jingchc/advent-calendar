//
//  DemoApp.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import SwiftData

@main
struct DemoApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            AdventDay.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            let container = try ModelContainer(for: schema, configurations: [modelConfiguration])
            // Load videos.json and populate SwiftData
            Task { @MainActor in
                let context = container.mainContext
                let descriptor = FetchDescriptor<AdventDay>()
                let existingCount = (try? context.fetchCount(descriptor)) ?? 0
                if existingCount == 0 {
                    let videos = VideoDataLoader.loadVideos()
                    for video in videos {
                        let adventDay = AdventDay(
                            day: video.day,
                            videoURL: video.videoURL,
                            title: video.title
                        )
                        context.insert(adventDay)
                    }
                    try? context.save()
                }
            }
            return container
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .preferredColorScheme(.light)
        }
        .modelContainer(sharedModelContainer)
    }
}
