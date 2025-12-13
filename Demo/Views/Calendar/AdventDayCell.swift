//
//  AdventDayCell.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import Dependencies

// MARK: - ViewModel

@Observable
final class AdventDayCellViewModel {
    @ObservationIgnored
    @Dependency(\.date) var dateProvider

    let day: AdventDay
    let isDebugMode: Bool

    init(day: AdventDay, isDebugMode: Bool = false) {
        self.day = day
        self.isDebugMode = isDebugMode
    }

    var theme: DayTheme {
        ThemeProvider.theme(for: day.day)
    }

    var canOpen: Bool {
        if isDebugMode { return true }
        let components = Calendar.current.dateComponents([.month, .day], from: dateProvider.now())
        return components.month == 12 && (components.day ?? 0) >= day.day
    }

    var isToday: Bool {
        let components = Calendar.current.dateComponents([.month, .day], from: dateProvider.now())
        return components.month == 12 && components.day == day.day
    }
}

// MARK: - View

struct AdventDayCell: View {

    @Bindable var viewModel: AdventDayCellViewModel
    @Dependency(\.router) var router
    @State private var showGiftAnimation = false

    init(day: AdventDay, isDebugMode: Bool = false) {
        self.viewModel = AdventDayCellViewModel(day: day, isDebugMode: isDebugMode)
    }

    private var day: AdventDay { viewModel.day }
    private var theme: DayTheme { viewModel.theme }
    private var canOpen: Bool { viewModel.canOpen }
    private var shouldGlow: Bool { viewModel.isToday && !day.isOpened }

    var body: some View {
        Button {
            let wasOpened = day.isOpened
            if !day.isOpened {
                day.isOpened = true
                day.openedAt = Date()
            }
            if wasOpened {
                router.push(.video(day), from: .calendar)
            } else {
                showGiftAnimation = true
            }
        } label: {
            ZStack {
                // Glow
                if shouldGlow {
                    GlowEffect(shape: RoundedRectangle(cornerRadius: 12))
                }

                // Background
                RoundedRectangle(cornerRadius: 12)
                    .fill(day.isOpened ? theme.opened.bgColor : theme.closed.bgColor)

                // Pattern overlay (only when not opened)
                if !day.isOpened {
                    theme.closed.patternView
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Content
                if day.isOpened {
                    theme.opened.iconView(font: .title)
                } else {
                    Text("\(day.day)")
                        .font(.appFont(size: 24, weight: .bold))
                        .foregroundColor(theme.closed.textColor)
                }
            }
            .frame(height: 65)
            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
        }
        .buttonStyle(.plain)
        .disabled(!canOpen)
        .opacity(canOpen ? 1.0 : 0.6)
        .accessibilityIdentifier(AccessibilityID.Calendar.dayCell(day.day))
        .fullScreenCover(isPresented: $showGiftAnimation) {
            GiftOpeningView(day: day) {
                showGiftAnimation = false
                router.push(.video(day), from: .calendar)
            }
        }
    }
}

#Preview("All States") {
    // 固定日期：12月15日
    withDependencies {
        $0.date = .fixed(month: 12, day: 15)
    } operation: {
        let closedDay = AdventDay(day: 10, videoURL: "", title: "Day 10")
        let openedDay = AdventDay(day: 10, videoURL: "", title: "Day 10")
        openedDay.isOpened = true
        let todayDay = AdventDay(day: 15, videoURL: "", title: "Day 15")
        let disabledDay = AdventDay(day: 25, videoURL: "", title: "Day 25")
        let preferredWidth = 65.0

        return VStack(spacing: 20) {
            HStack(spacing: 16) {
                VStack {
                    AdventDayCell(day: closedDay)
                        .frame(width: preferredWidth)
                    Text("Closed").font(.caption)
                }

                VStack {
                    AdventDayCell(day: openedDay)
                        .frame(width: preferredWidth)
                    Text("Opened").font(.caption)
                }
            }

            HStack(spacing: 16) {
                VStack {
                    AdventDayCell(day: todayDay)
                        .frame(width: preferredWidth)
                    Text("Today").font(.caption)
                }

                VStack {
                    AdventDayCell(day: disabledDay)
                        .frame(width: preferredWidth)
                    Text("Disabled").font(.caption)
                }
            }
        }
        .padding()
        .appBackground()
    }
}
