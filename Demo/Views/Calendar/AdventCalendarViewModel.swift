//
//  AdventCalendarViewModel.swift
//  Demo
//
//  Created by JingChuang on 2025/12/13.
//

import SwiftUI
import Dependencies

@Observable
final class AdventCalendarViewModel {
    @ObservationIgnored
    @Dependency(\.database) var database

    // MARK: - State

    private(set) var isDebugMode = false
    private(set) var showCelebration = false
    private var tapCount = 0
    private var hasShownCelebration = false

    // MARK: - Computed Properties

    func allOpened(days: [AdventDay]) -> Bool {
        days.allSatisfy { $0.isOpened }
    }

    func allFavorite(days: [AdventDay]) -> Bool {
        days.allSatisfy { $0.isFavorite }
    }

    // MARK: - Actions

    func handleVersionTap() {
        tapCount += 1
        if tapCount >= 5 {
            isDebugMode.toggle()
            tapCount = 0
        }
    }

    func toggleAllOpen(days: [AdventDay]) {
        if allOpened(days: days) {
            database.resetAllDays()
        } else {
            database.openAllDays()
        }
    }

    func toggleAllFavorite(days: [AdventDay]) {
        if allFavorite(days: days) {
            database.unfavoriteAll()
        } else {
            database.favoriteAll()
        }
    }

    func checkCelebration(days: [AdventDay]) {
        if allOpened(days: days) && !hasShownCelebration && !days.isEmpty {
            hasShownCelebration = true
            showCelebration = true
        }
    }

    func dismissCelebration() {
        showCelebration = false
    }
}
