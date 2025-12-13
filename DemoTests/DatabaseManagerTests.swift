//
//  DatabaseManagerTests.swift
//  DemoTests
//
//  Created by JingChuang on 2025/12/13.
//

import Testing
import SwiftData
import Dependencies
import Foundation
@testable import Demo

@MainActor
struct DatabaseManagerTests {

    // MARK: - Helper

    private func seedTestData(manager: DatabaseManager, count: Int = 3) {
        let context = manager.container.mainContext
        for day in 1...count {
            let adventDay = AdventDay(day: day, videoURL: "https://example.com/\(day)", title: "Day \(day)")
            context.insert(adventDay)
        }
        try? context.save()
    }

    private func fetchAllDays(manager: DatabaseManager) -> [AdventDay] {
        let context = manager.container.mainContext
        let descriptor = FetchDescriptor<AdventDay>()
        return (try? context.fetch(descriptor)) ?? []
    }

    // MARK: - openAllDays Tests

    @Test("openAllDays opens all days")
    func openAllDaysOpensAll() {
        withDependencies {
            $0.database = DatabaseManager(inMemory: true)
        } operation: {
            @Dependency(\.database) var database
            seedTestData(manager: database)

            database.openAllDays()

            let days = fetchAllDays(manager: database)
            #expect(days.allSatisfy { $0.isOpened })
            #expect(days.allSatisfy { $0.openedAt != nil })
        }
    }

    @Test("openAllDays does not update already opened days")
    func openAllDaysPreservesExisting() {
        withDependencies {
            $0.database = DatabaseManager(inMemory: true)
        } operation: {
            @Dependency(\.database) var database
            seedTestData(manager: database)

            let days = fetchAllDays(manager: database)
            let firstDay = days.first!
            let originalDate = Date.distantPast
            firstDay.isOpened = true
            firstDay.openedAt = originalDate
            try? database.container.mainContext.save()

            database.openAllDays()

            let updatedDays = fetchAllDays(manager: database)
            let updatedFirst = updatedDays.first { $0.day == firstDay.day }!
            #expect(updatedFirst.openedAt == originalDate)
        }
    }

    // MARK: - resetAllDays Tests

    @Test("resetAllDays resets all days")
    func resetAllDaysResetsAll() {
        withDependencies {
            $0.database = DatabaseManager(inMemory: true)
        } operation: {
            @Dependency(\.database) var database
            seedTestData(manager: database)

            database.openAllDays()
            database.resetAllDays()

            let days = fetchAllDays(manager: database)
            #expect(days.allSatisfy { !$0.isOpened })
            #expect(days.allSatisfy { $0.openedAt == nil })
        }
    }

    // MARK: - favoriteAll Tests

    @Test("favoriteAll favorites all days")
    func favoriteAllFavoritesAll() {
        withDependencies {
            $0.database = DatabaseManager(inMemory: true)
        } operation: {
            @Dependency(\.database) var database
            seedTestData(manager: database)

            database.favoriteAll()

            let days = fetchAllDays(manager: database)
            #expect(days.allSatisfy { $0.isFavorite })
        }
    }

    // MARK: - unfavoriteAll Tests

    @Test("unfavoriteAll unfavorites all days")
    func unfavoriteAllUnfavoritesAll() {
        withDependencies {
            $0.database = DatabaseManager(inMemory: true)
        } operation: {
            @Dependency(\.database) var database
            seedTestData(manager: database)

            database.favoriteAll()
            database.unfavoriteAll()

            let days = fetchAllDays(manager: database)
            #expect(days.allSatisfy { !$0.isFavorite })
        }
    }

    // MARK: - markFavorites Tests

    @Test("markFavorites marks specific days as favorites")
    func markFavoritesMarksSpecificDays() {
        withDependencies {
            $0.database = DatabaseManager(inMemory: true)
        } operation: {
            @Dependency(\.database) var database
            seedTestData(manager: database, count: 5)

            database.markFavorites(days: [1, 3])

            let days = fetchAllDays(manager: database)
            let favoriteDays = days.filter { $0.isFavorite }
            #expect(favoriteDays.count == 2)
            #expect(favoriteDays.contains { $0.day == 1 })
            #expect(favoriteDays.contains { $0.day == 3 })
        }
    }

    @Test("markFavorites also opens the days")
    func markFavoritesAlsoOpensDays() {
        withDependencies {
            $0.database = DatabaseManager(inMemory: true)
        } operation: {
            @Dependency(\.database) var database
            seedTestData(manager: database, count: 5)

            database.markFavorites(days: [2, 4])

            let days = fetchAllDays(manager: database)
            let openedDays = days.filter { $0.isOpened }
            #expect(openedDays.count == 2)
            #expect(openedDays.allSatisfy { $0.isFavorite })
        }
    }

    // MARK: - seedIfNeeded Tests

    @Test("seedIfNeeded does not duplicate data when called twice")
    func seedIfNeededNoDuplicates() {
        withDependencies {
            $0.database = DatabaseManager(inMemory: true)
        } operation: {
            @Dependency(\.database) var database
            seedTestData(manager: database, count: 3)

            let countBefore = fetchAllDays(manager: database).count
            database.seedIfNeeded()
            let countAfter = fetchAllDays(manager: database).count

            #expect(countBefore == countAfter)
        }
    }

    // MARK: - Edge Cases

    @Test("operations work on empty database")
    func operationsOnEmptyDatabase() {
        withDependencies {
            $0.database = DatabaseManager(inMemory: true)
        } operation: {
            @Dependency(\.database) var database

            database.openAllDays()
            database.resetAllDays()
            database.favoriteAll()
            database.unfavoriteAll()

            let days = fetchAllDays(manager: database)
            #expect(days.isEmpty)
        }
    }
}
