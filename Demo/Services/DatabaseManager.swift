//
//  DatabaseManager.swift
//  Demo
//
//  Created by JingChuang on 2025/12/13.
//

import SwiftData
import Dependencies
import Foundation

@MainActor
final class DatabaseManager {
    let container: ModelContainer

    init(inMemory: Bool = false) {
        let schema = Schema([AdventDay.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory)

        do {
            container = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    func seedIfNeeded() {
        let context = container.mainContext
        let descriptor = FetchDescriptor<AdventDay>()
        let existingCount = (try? context.fetchCount(descriptor)) ?? 0

        guard existingCount == 0 else { return }

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

    // MARK: - Day Operations

    func openAllDays() {
        let context = container.mainContext
        let descriptor = FetchDescriptor<AdventDay>()
        guard let days = try? context.fetch(descriptor) else { return }

        for day in days {
            if !day.isOpened {
                day.isOpened = true
                day.openedAt = Date()
            }
        }
        try? context.save()
    }

    func resetAllDays() {
        let context = container.mainContext
        let descriptor = FetchDescriptor<AdventDay>()
        guard let days = try? context.fetch(descriptor) else { return }

        for day in days {
            day.isOpened = false
            day.openedAt = nil
        }
        try? context.save()
    }

    func favoriteAll() {
        let context = container.mainContext
        let descriptor = FetchDescriptor<AdventDay>()
        guard let days = try? context.fetch(descriptor) else { return }

        for day in days {
            day.isFavorite = true
        }
        try? context.save()
    }

    func unfavoriteAll() {
        let context = container.mainContext
        let descriptor = FetchDescriptor<AdventDay>()
        guard let days = try? context.fetch(descriptor) else { return }

        for day in days {
            day.isFavorite = false
        }
        try? context.save()
    }

    func markFavorites(days: [Int] = [1, 3, 6, 12, 25]) {
        let context = container.mainContext
        let predicate = #Predicate<AdventDay> { days.contains($0.day) }
        let descriptor = FetchDescriptor<AdventDay>(predicate: predicate)
        guard let adventDays = try? context.fetch(descriptor) else { return }

        for day in adventDays {
            day.isOpened = true
            day.openedAt = Date()
            day.isFavorite = true
        }
        try? context.save()
    }
}

// MARK: - Dependency

extension DatabaseManager: DependencyKey {
    static let liveValue = DatabaseManager()
    static var previewValue: DatabaseManager {
        let manager = DatabaseManager(inMemory: true)
        manager.seedIfNeeded()
        return manager
    }
    static var testValue: DatabaseManager { DatabaseManager(inMemory: true) }
}

extension DependencyValues {
    var database: DatabaseManager {
        get { self[DatabaseManager.self] }
        set { self[DatabaseManager.self] = newValue }
    }
}
