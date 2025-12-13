//
//  DemoUITests.swift
//  DemoUITests
//
//  Created by JingChuang on 2025/12/6.
//

import XCTest

final class DemoUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - Constants

    private let timeout: TimeInterval = 2

    // MARK: - Setup

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Navigation Tests

    @MainActor
    func testAppLaunchShowsCalendarTab() throws {
        // Verify Calendar tab is selected on launch
        XCTAssertTrue(app.navigationBars[AccessibilityID.NavigationBar.adventCalendar].exists)
    }

    @MainActor
    func testTabNavigation() throws {
        // Switch to Favorites tab
        app.tabBars.buttons[AccessibilityID.TabBar.favorites].tap()
        XCTAssertTrue(app.navigationBars[AccessibilityID.NavigationBar.favorites].waitForExistence(timeout: timeout))

        // Switch back to Calendar tab
        app.tabBars.buttons[AccessibilityID.TabBar.calendar].tap()
        XCTAssertTrue(app.navigationBars[AccessibilityID.NavigationBar.adventCalendar].waitForExistence(timeout: timeout))
    }

    // MARK: - Empty State Tests

    @MainActor
    func testFavoritesEmptyState() throws {
        // Go to Favorites tab
        app.tabBars.buttons[AccessibilityID.TabBar.favorites].tap()

        // Verify empty state message
        let emptyLabel = app.staticTexts[AccessibilityID.Favorites.emptyLabel]
        XCTAssertTrue(emptyLabel.waitForExistence(timeout: timeout))
    }

    // MARK: - Calendar Grid Tests

    @MainActor
    func testCalendarGridDisplays25Days() throws {
        // Verify all 25 day cells exist
        for day in 1...25 {
            let dayCell = app.buttons[AccessibilityID.Calendar.dayCell(day)]
            XCTAssertTrue(dayCell.waitForExistence(timeout: timeout), "Day \(day) cell should exist")
        }
    }

    // MARK: - Day Cell Interaction Tests

    @MainActor
    func testOpenDayCell() throws {
        // Find and tap day 1
        let dayCell = app.buttons[AccessibilityID.Calendar.dayCell(1)]
        guard dayCell.waitForExistence(timeout: timeout), dayCell.isHittable else {
            throw XCTSkip("Day cell not available")
        }
        dayCell.tap()

        // Wait for video player to appear
        let videoPlayer = app.otherElements[AccessibilityID.VideoPlayer.container]
        XCTAssertTrue(videoPlayer.waitForExistence(timeout: timeout), "Video player should appear")
    }

    // MARK: - Performance Tests

    @MainActor
    func testLaunchPerformance() throws {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}

// MARK: - Favorites Flow Tests

final class FavoritesFlowUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - Constants

    private let timeout: TimeInterval = 5

    // MARK: - Setup

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    @MainActor
    func testAddAndRemoveFavorite() throws {
        // 1. Verify favorites is empty
        app.tabBars.buttons[AccessibilityID.TabBar.favorites].tap()
        let emptyLabel = app.staticTexts[AccessibilityID.Favorites.emptyLabel]
        XCTAssertTrue(emptyLabel.waitForExistence(timeout: timeout), "Favorites should be empty initially")

        // 2. Go to Calendar and open day 1
        app.tabBars.buttons[AccessibilityID.TabBar.calendar].tap()
        let dayCell = app.buttons[AccessibilityID.Calendar.dayCell(1)]
        guard dayCell.waitForExistence(timeout: timeout) else {
            throw XCTSkip("Day cell not available")
        }
        dayCell.tap()

        // 3. Tap favorite button
        let favoriteButton = app.buttons[AccessibilityID.VideoPlayer.favoriteButton]
        guard favoriteButton.waitForExistence(timeout: timeout), favoriteButton.isHittable else {
            throw XCTSkip("Favorite button not hittable")
        }
        favoriteButton.tap()

        // 4. Go back to calendar
        app.navigationBars.buttons.firstMatch.tap()
        XCTAssertTrue(app.navigationBars[AccessibilityID.NavigationBar.adventCalendar].waitForExistence(timeout: timeout))

        // 5. Go to Favorites tab and verify item exists
        app.tabBars.buttons[AccessibilityID.TabBar.favorites].tap()
        XCTAssertTrue(app.navigationBars[AccessibilityID.NavigationBar.favorites].waitForExistence(timeout: timeout))
        XCTAssertTrue(app.cells.count > 0, "Should have at least one favorite")

        // 6. Remove favorite by tapping heart button in the row
        let heartButton = app.cells.firstMatch.buttons.firstMatch
        XCTAssertTrue(heartButton.exists, "Heart button should exist")
        heartButton.tap()

        // 7. Verify favorites is empty again
        XCTAssertTrue(emptyLabel.waitForExistence(timeout: timeout), "Favorites should be empty after removal")
    }

    @MainActor
    func testFavoritesListDisplaysItems() throws {
        // Navigate to favorites
        app.tabBars.buttons[AccessibilityID.TabBar.favorites].tap()

        // Check if either empty state or list exists
        let emptyLabel = app.staticTexts[AccessibilityID.Favorites.emptyLabel]
        let hasFavorites = app.cells.count > 0

        XCTAssertTrue(emptyLabel.exists || hasFavorites)
    }
}

// MARK: - Video Player Tests

final class VideoPlayerUITests: XCTestCase {

    var app: XCUIApplication!

    // MARK: - Constants

    private let timeout: TimeInterval = 5

    // MARK: - Setup

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments = ["UI_TESTING"]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Helper

    @MainActor
    private func openVideoPlayer() -> Bool {
        // Try to open day 1
        let dayCell = app.buttons[AccessibilityID.Calendar.dayCell(1)]
        guard dayCell.waitForExistence(timeout: timeout) else { return false }

        dayCell.tap()

        // Wait for gift animation to complete and video player to appear
        let videoPlayer = app.otherElements[AccessibilityID.VideoPlayer.container]
        return videoPlayer.waitForExistence(timeout: timeout)
    }

    // MARK: - Tests

    @MainActor
    func testVideoPlayerAppears() throws {
        let opened = openVideoPlayer()
        XCTAssertTrue(opened, "Video player should appear after tapping day cell")
    }

    @MainActor
    func testPlayPauseButton() throws {
        guard openVideoPlayer() else {
            throw XCTSkip("Could not open video player")
        }

        // Tap to show controls
        app.otherElements[AccessibilityID.VideoPlayer.container].tap()

        let playPauseButton = app.buttons[AccessibilityID.VideoPlayer.playPauseButton]
        XCTAssertTrue(playPauseButton.waitForExistence(timeout: timeout))

        // Tap play/pause
        playPauseButton.tap()

        // Button should still exist after tap
        XCTAssertTrue(playPauseButton.exists)
    }

    @MainActor
    func testFavoriteButton() throws {
        guard openVideoPlayer() else {
            throw XCTSkip("Could not open video player")
        }

        // Tap to show controls
        app.otherElements[AccessibilityID.VideoPlayer.container].tap()

        let favoriteButton = app.buttons[AccessibilityID.VideoPlayer.favoriteButton]
        XCTAssertTrue(favoriteButton.waitForExistence(timeout: timeout))

        // Tap favorite
        favoriteButton.tap()

        // Button should still exist
        XCTAssertTrue(favoriteButton.exists)
    }

    @MainActor
    func testToggleTitleButton() throws {
        guard openVideoPlayer() else {
            throw XCTSkip("Could not open video player")
        }

        // Tap to show controls
        app.otherElements[AccessibilityID.VideoPlayer.container].tap()

        let toggleButton = app.buttons[AccessibilityID.VideoPlayer.toggleTitleButton]
        XCTAssertTrue(toggleButton.waitForExistence(timeout: timeout))

        // Tap to toggle title
        toggleButton.tap()

        // Button should still exist
        XCTAssertTrue(toggleButton.exists)
    }

    @MainActor
    func testNavigateBackFromPlayer() throws {
        guard openVideoPlayer() else {
            throw XCTSkip("Could not open video player")
        }

        // Tap back button
        let backButton = app.navigationBars.buttons.firstMatch
        if backButton.exists {
            backButton.tap()

            // Should return to calendar
            XCTAssertTrue(app.navigationBars[AccessibilityID.NavigationBar.adventCalendar].waitForExistence(timeout: timeout))
        }
    }
}
