//
//  AdventCalendarViewModelTests.swift
//  DemoTests
//
//  Created by JingChuang on 2025/12/13.
//

import Testing
import Dependencies
@testable import Demo

struct AdventCalendarViewModelTests {

    // MARK: - allOpened Tests

    @Test("allOpened returns true when all days are opened")
    func allOpenedReturnsTrue() {
        let viewModel = AdventCalendarViewModel()
        let days = (1...3).map { day -> AdventDay in
            let adventDay = AdventDay(day: day, videoURL: "", title: "Day \(day)")
            adventDay.isOpened = true
            return adventDay
        }

        #expect(viewModel.allOpened(days: days) == true)
    }

    @Test("allOpened returns false when some days are not opened")
    func allOpenedReturnsFalse() {
        let viewModel = AdventCalendarViewModel()
        let days = (1...3).map { day -> AdventDay in
            let adventDay = AdventDay(day: day, videoURL: "", title: "Day \(day)")
            adventDay.isOpened = day <= 2 // Only first 2 opened
            return adventDay
        }

        #expect(viewModel.allOpened(days: days) == false)
    }

    @Test("allOpened returns true for empty array")
    func allOpenedEmptyArray() {
        let viewModel = AdventCalendarViewModel()
        #expect(viewModel.allOpened(days: []) == true)
    }

    // MARK: - allFavorite Tests

    @Test("allFavorite returns true when all days are favorited")
    func allFavoriteReturnsTrue() {
        let viewModel = AdventCalendarViewModel()
        let days = (1...3).map { day -> AdventDay in
            let adventDay = AdventDay(day: day, videoURL: "", title: "Day \(day)")
            adventDay.isFavorite = true
            return adventDay
        }

        #expect(viewModel.allFavorite(days: days) == true)
    }

    @Test("allFavorite returns false when some days are not favorited")
    func allFavoriteReturnsFalse() {
        let viewModel = AdventCalendarViewModel()
        let days = (1...3).map { day -> AdventDay in
            let adventDay = AdventDay(day: day, videoURL: "", title: "Day \(day)")
            adventDay.isFavorite = day == 1 // Only first one favorited
            return adventDay
        }

        #expect(viewModel.allFavorite(days: days) == false)
    }

    // MARK: - Debug Mode Tests

    @Test("handleVersionTap toggles debug mode after 5 taps")
    func debugModeTogglesAfter5Taps() {
        let viewModel = AdventCalendarViewModel()

        #expect(viewModel.isDebugMode == false)

        // Tap 4 times - should not toggle
        for _ in 1...4 {
            viewModel.handleVersionTap()
        }
        #expect(viewModel.isDebugMode == false)

        // 5th tap - should toggle
        viewModel.handleVersionTap()
        #expect(viewModel.isDebugMode == true)
    }

    @Test("handleVersionTap resets counter after toggle")
    func debugModeResetsCounter() {
        let viewModel = AdventCalendarViewModel()

        // Toggle on
        for _ in 1...5 {
            viewModel.handleVersionTap()
        }
        #expect(viewModel.isDebugMode == true)

        // Toggle off (another 5 taps)
        for _ in 1...5 {
            viewModel.handleVersionTap()
        }
        #expect(viewModel.isDebugMode == false)
    }

    // MARK: - Celebration Tests

    @Test("checkCelebration shows celebration when all opened")
    func celebrationShowsWhenAllOpened() {
        let viewModel = AdventCalendarViewModel()
        let days = (1...3).map { day -> AdventDay in
            let adventDay = AdventDay(day: day, videoURL: "", title: "Day \(day)")
            adventDay.isOpened = true
            return adventDay
        }

        #expect(viewModel.showCelebration == false)
        viewModel.checkCelebration(days: days)
        #expect(viewModel.showCelebration == true)
    }

    @Test("checkCelebration does not show for empty days")
    func celebrationNotShownForEmptyDays() {
        let viewModel = AdventCalendarViewModel()

        viewModel.checkCelebration(days: [])
        #expect(viewModel.showCelebration == false)
    }

    @Test("checkCelebration only shows once")
    func celebrationOnlyShowsOnce() {
        let viewModel = AdventCalendarViewModel()
        let days = (1...3).map { day -> AdventDay in
            let adventDay = AdventDay(day: day, videoURL: "", title: "Day \(day)")
            adventDay.isOpened = true
            return adventDay
        }

        viewModel.checkCelebration(days: days)
        #expect(viewModel.showCelebration == true)

        viewModel.dismissCelebration()
        #expect(viewModel.showCelebration == false)

        // Check again - should not show
        viewModel.checkCelebration(days: days)
        #expect(viewModel.showCelebration == false)
    }

    @Test("dismissCelebration sets showCelebration to false")
    func dismissCelebrationWorks() {
        let viewModel = AdventCalendarViewModel()
        let days = [AdventDay(day: 1, videoURL: "", title: "Day 1")]
        days[0].isOpened = true

        viewModel.checkCelebration(days: days)
        #expect(viewModel.showCelebration == true)

        viewModel.dismissCelebration()
        #expect(viewModel.showCelebration == false)
    }
}
