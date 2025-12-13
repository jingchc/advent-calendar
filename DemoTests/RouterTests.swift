//
//  RouterTests.swift
//  DemoTests
//
//  Created by JingChuang on 2025/12/13.
//

import Testing
import SwiftUI
import Dependencies
@testable import Demo

struct RouterTests {

    // MARK: - Push Tests

    @Test("push appends to calendarPath for calendar tab")
    func pushToCalendarTab() {
        let router = Router()
        let day = AdventDay(day: 1, videoURL: "https://example.com", title: "Day 1")

        router.push(.video(day), from: .calendar)

        #expect(router.calendarPath.count == 1)
        #expect(router.favoritesPath.count == 0)
    }

    @Test("push appends to favoritesPath for favorites tab")
    func pushToFavoritesTab() {
        let router = Router()
        let day = AdventDay(day: 1, videoURL: "https://example.com", title: "Day 1")

        router.push(.video(day), from: .favorites)

        #expect(router.favoritesPath.count == 1)
        #expect(router.calendarPath.count == 0)
    }

    @Test("multiple pushes stack correctly")
    func multiplePushesStack() {
        let router = Router()
        let day1 = AdventDay(day: 1, videoURL: "https://example.com/1", title: "Day 1")
        let day2 = AdventDay(day: 2, videoURL: "https://example.com/2", title: "Day 2")

        router.push(.video(day1), from: .calendar)
        router.push(.video(day2), from: .calendar)

        #expect(router.calendarPath.count == 2)
    }

    // MARK: - Pop Tests

    @Test("pop removes last from calendarPath")
    func popFromCalendarTab() {
        let router = Router()
        let day = AdventDay(day: 1, videoURL: "https://example.com", title: "Day 1")
        router.push(.video(day), from: .calendar)

        router.pop(from: .calendar)

        #expect(router.calendarPath.count == 0)
    }

    @Test("pop removes last from favoritesPath")
    func popFromFavoritesTab() {
        let router = Router()
        let day = AdventDay(day: 1, videoURL: "https://example.com", title: "Day 1")
        router.push(.video(day), from: .favorites)

        router.pop(from: .favorites)

        #expect(router.favoritesPath.count == 0)
    }

    @Test("pop on empty path does not crash")
    func popOnEmptyPathSafe() {
        let router = Router()

        router.pop(from: .calendar)
        router.pop(from: .favorites)

        #expect(router.calendarPath.count == 0)
        #expect(router.favoritesPath.count == 0)
    }

    @Test("pop only removes one item")
    func popRemovesOnlyOne() {
        let router = Router()
        let day1 = AdventDay(day: 1, videoURL: "https://example.com/1", title: "Day 1")
        let day2 = AdventDay(day: 2, videoURL: "https://example.com/2", title: "Day 2")
        router.push(.video(day1), from: .calendar)
        router.push(.video(day2), from: .calendar)

        router.pop(from: .calendar)

        #expect(router.calendarPath.count == 1)
    }

    // MARK: - PopToRoot Tests

    @Test("popToRoot clears calendarPath")
    func popToRootClearsCalendar() {
        let router = Router()
        let day1 = AdventDay(day: 1, videoURL: "https://example.com/1", title: "Day 1")
        let day2 = AdventDay(day: 2, videoURL: "https://example.com/2", title: "Day 2")
        router.push(.video(day1), from: .calendar)
        router.push(.video(day2), from: .calendar)

        router.popToRoot(tab: .calendar)

        #expect(router.calendarPath.count == 0)
    }

    @Test("popToRoot clears favoritesPath")
    func popToRootClearsFavorites() {
        let router = Router()
        let day1 = AdventDay(day: 1, videoURL: "https://example.com/1", title: "Day 1")
        let day2 = AdventDay(day: 2, videoURL: "https://example.com/2", title: "Day 2")
        router.push(.video(day1), from: .favorites)
        router.push(.video(day2), from: .favorites)

        router.popToRoot(tab: .favorites)

        #expect(router.favoritesPath.count == 0)
    }

    @Test("popToRoot on one tab does not affect other tab")
    func popToRootIsolated() {
        let router = Router()
        let day = AdventDay(day: 1, videoURL: "https://example.com", title: "Day 1")
        router.push(.video(day), from: .calendar)
        router.push(.video(day), from: .favorites)

        router.popToRoot(tab: .calendar)

        #expect(router.calendarPath.count == 0)
        #expect(router.favoritesPath.count == 1)
    }

    // MARK: - Dependency Tests

    @Test("Router works with dependency injection")
    func routerWithDependencies() {
        withDependencies {
            $0.router = Router()
        } operation: {
            @Dependency(\.router) var router
            let day = AdventDay(day: 1, videoURL: "https://example.com", title: "Day 1")

            router.push(.video(day), from: .calendar)

            #expect(router.calendarPath.count == 1)
        }
    }
}
