//
//  AdventDayCell.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI

struct AdventDayCell: View {
    @Bindable var day: AdventDay
    var isDebugMode: Bool = false
    @State private var showGiftAnimation = false
    @State private var showVideo = false
    @State private var isGlowing = false

    private var cellStyle: CellStyle {
        CellStyles.cellStyle(for: day.day)
    }

    private var openedStyle: OpenedStyle {
        CellStyles.openedStyle(for: day.day)
    }

    private var canOpen: Bool {
        if isDebugMode { return true }

        let calendar = Calendar.current
        let today = Date()
        let currentYear = calendar.component(.year, from: today)

        guard let adventDate = calendar.date(from: DateComponents(year: currentYear, month: 12, day: day.day)) else {
            return false
        }

        return today >= adventDate
    }

    private var isToday: Bool {
        let calendar = Calendar.current
        let today = Date()
        let currentDay = calendar.component(.day, from: today)
        let currentMonth = calendar.component(.month, from: today)
        return currentMonth == 12 && currentDay == day.day
    }

    var body: some View {
        Button {
            if canOpen {
                let wasOpened = day.isOpened
                if !day.isOpened {
                    day.isOpened = true
                    day.openedAt = Date()
                }
                if wasOpened {
                    showVideo = true
                } else {
                    showGiftAnimation = true
                }
            }
        } label: {
            ZStack {
                if isToday && !day.isOpened {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.yellow.opacity(0.6))
                        .blur(radius: isGlowing ? 8 : 4)
                        .scaleEffect(isGlowing ? 1.1 : 1.0)
                }

                // Background
                RoundedRectangle(cornerRadius: 12)
                    .fill(day.isOpened ? openedStyle.bgColor : cellStyle.bgColor)

                // Pattern overlay (only when not opened)
                if !day.isOpened {
                    cellStyle.patternView
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                // Content
                if day.isOpened {
                    openedStyle.iconView(font: .title)
                } else {
                    Text("\(day.day)")
                        .font(.appFont(size: 24, weight: .bold))
                        .foregroundColor(cellStyle.textColor)
                }

            }
            .frame(height: 65)
            .shadow(color: .black.opacity(0.15), radius: 2, x: 0, y: 1)
            .opacity(canOpen ? 1.0 : 0.6)
        }
        .buttonStyle(.plain)
        .fullScreenCover(isPresented: $showGiftAnimation) {
            GiftOpeningView(day: day) {
                showGiftAnimation = false
                showVideo = true
            }
        }
        .fullScreenCover(isPresented: $showVideo) {
            VideoPlayerView(day: day)
        }
        .onAppear {
            if isToday && !day.isOpened {
                withAnimation(
                    .easeInOut(duration: 1.0)
                    .repeatForever(autoreverses: true)
                ) {
                    isGlowing = true
                }
            }
        }
    }
}

#Preview {
    let day = AdventDay(day: 6, videoURL: "", title: "Day 6")
    return AdventDayCell(day: day)
        .padding()
        .background(Color.appBackground)
}

#Preview("Opened") {
    let day = AdventDay(day: 6, videoURL: "", title: "Day 6")
    day.isOpened = true
    return AdventDayCell(day: day)
        .padding()
        .background(Color.appBackground)
}
