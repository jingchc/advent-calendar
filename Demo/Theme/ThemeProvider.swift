//
//  ThemeProvider.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI

// MARK: - Pattern

enum PatternType {
    case dots, stripes, zigzag, diamonds
}

// MARK: - Styles

struct ClosedStyle {
    let bgColor: Color
    let textColor: Color
    let pattern: PatternType

    @ViewBuilder
    var patternView: some View {
        let patternColor = textColor.opacity(0.15)
        switch pattern {
        case .dots:
            DotsPattern(color: patternColor)
        case .stripes:
            StripesPattern(color: patternColor)
        case .zigzag:
            ZigzagPattern(color: patternColor)
        case .diamonds:
            DiamondsPattern(color: patternColor)
        }
    }
}

struct OpenedStyle {
    let icon: String
    let bgColor: Color
    let iconColor: Color

    var isEmoji: Bool {
        icon.unicodeScalars.first?.properties.isEmoji ?? false
    }

    @ViewBuilder
    func iconView(font: Font = .title) -> some View {
        if isEmoji {
            Text(icon)
                .font(font)
        } else {
            Image(systemName: icon)
                .font(font)
                .foregroundColor(iconColor)
        }
    }
}

// MARK: - Day Theme

struct DayTheme {
    let closed: ClosedStyle
    let opened: OpenedStyle
}

// MARK: - Theme Provider

enum ThemeProvider {
    private static let themes: [Int: DayTheme] = [
        1: DayTheme(
            closed: .init(bgColor: .christmasRed, textColor: .white, pattern: .zigzag),
            opened: .init(icon: "gift.fill", bgColor: .christmasRed, iconColor: .cream)
        ),
        2: DayTheme(
            closed: .init(bgColor: .cream, textColor: .warmBrown, pattern: .dots),
            opened: .init(icon: "🎄", bgColor: .cream, iconColor: .forestGreen)
        ),
        3: DayTheme(
            closed: .init(bgColor: .christmasRed, textColor: .cream, pattern: .stripes),
            opened: .init(icon: "bell.fill", bgColor: .forestGreen, iconColor: .white)
        ),
        4: DayTheme(
            closed: .init(bgColor: .forestGreen, textColor: .white, pattern: .diamonds),
            opened: .init(icon: "star.fill", bgColor: .beige, iconColor: .christmasRed)
        ),
        5: DayTheme(
            closed: .init(bgColor: .beige, textColor: .warmBrown, pattern: .stripes),
            opened: .init(icon: "heart.fill", bgColor: .christmasRed, iconColor: .white)
        ),
        6: DayTheme(
            closed: .init(bgColor: .darkGreen, textColor: .white, pattern: .dots),
            opened: .init(icon: "snowflake", bgColor: .darkGreen, iconColor: .white)
        ),
        7: DayTheme(
            closed: .init(bgColor: .cream, textColor: .christmasRed, pattern: .zigzag),
            opened: .init(icon: "sparkles", bgColor: .cream, iconColor: .christmasRed)
        ),
        8: DayTheme(
            closed: .init(bgColor: .christmasRed, textColor: .white, pattern: .dots),
            opened: .init(icon: "moon.stars.fill", bgColor: .forestGreen, iconColor: .cream)
        ),
        9: DayTheme(
            closed: .init(bgColor: .beige, textColor: .warmBrown, pattern: .diamonds),
            opened: .init(icon: "☕️", bgColor: .warmBrown, iconColor: .cream)
        ),
        10: DayTheme(
            closed: .init(bgColor: .forestGreen, textColor: .cream, pattern: .zigzag),
            opened: .init(icon: "house.fill", bgColor: .beige, iconColor: .forestGreen)
        ),
        11: DayTheme(
            closed: .init(bgColor: .warmBrown, textColor: .cream, pattern: .stripes),
            opened: .init(icon: "music.note", bgColor: .christmasRed, iconColor: .white)
        ),
        12: DayTheme(
            closed: .init(bgColor: .cream, textColor: .forestGreen, pattern: .diamonds),
            opened: .init(icon: "🌈", bgColor: .forestGreen, iconColor: .cream)
        ),
        13: DayTheme(
            closed: .init(bgColor: .christmasRed, textColor: .cream, pattern: .zigzag),
            opened: .init(icon: "flame.fill", bgColor: .christmasRed, iconColor: .orange)
        ),
        14: DayTheme(
            closed: .init(bgColor: .beige, textColor: .christmasRed, pattern: .dots),
            opened: .init(icon: "🐱", bgColor: .cream, iconColor: .forestGreen)
        ),
        15: DayTheme(
            closed: .init(bgColor: .darkGreen, textColor: .white, pattern: .diamonds),
            opened: .init(icon: "⛄️", bgColor: .darkGreen, iconColor: .white)
        ),
        16: DayTheme(
            closed: .init(bgColor: .cream, textColor: .warmBrown, pattern: .stripes),
            opened: .init(icon: "crown.fill", bgColor: .beige, iconColor: .christmasRed)
        ),
        17: DayTheme(
            closed: .init(bgColor: .forestGreen, textColor: .white, pattern: .zigzag),
            opened: .init(icon: "fireworks", bgColor: .christmasRed, iconColor: .cream)
        ),
        18: DayTheme(
            closed: .init(bgColor: .christmasRed, textColor: .white, pattern: .diamonds),
            opened: .init(icon: "hands.clap.fill", bgColor: .warmBrown, iconColor: .white)
        ),
        19: DayTheme(
            closed: .init(bgColor: .beige, textColor: .forestGreen, pattern: .dots),
            opened: .init(icon: "party.popper.fill", bgColor: .forestGreen, iconColor: .white)
        ),
        20: DayTheme(
            closed: .init(bgColor: .darkGreen, textColor: .cream, pattern: .stripes),
            opened: .init(icon: "book.fill", bgColor: .beige, iconColor: .warmBrown)
        ),
        21: DayTheme(
            closed: .init(bgColor: .warmBrown, textColor: .white, pattern: .diamonds),
            opened: .init(icon: "🏆", bgColor: .cream, iconColor: .white)
        ),
        22: DayTheme(
            closed: .init(bgColor: .cream, textColor: .christmasRed, pattern: .zigzag),
            opened: .init(icon: "sun.max.fill", bgColor: .christmasRed, iconColor: .yellow)
        ),
        23: DayTheme(
            closed: .init(bgColor: .forestGreen, textColor: .cream, pattern: .zigzag),
            opened: .init(icon: "🕊️", bgColor: .forestGreen, iconColor: .white)
        ),
        24: DayTheme(
            closed: .init(bgColor: .christmasRed, textColor: .white, pattern: .stripes),
            opened: .init(icon: "wand.and.stars", bgColor: .darkGreen, iconColor: .white)
        ),
        25: DayTheme(
            closed: .init(bgColor: .darkGreen, textColor: .white, pattern: .dots),
            opened: .init(icon: "🎅🏻", bgColor: .christmasRed, iconColor: .white)
        ),
    ]

    private static let defaultTheme = DayTheme(
        closed: .init(bgColor: .gray, textColor: .white, pattern: .dots),
        opened: .init(icon: "gift.fill", bgColor: .gray, iconColor: .white)
    )

    static func theme(for day: Int) -> DayTheme {
        themes[day] ?? defaultTheme
    }
}

// MARK: - Preview

#Preview("Closed Styles") {
    ScrollView {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
            ForEach(1...25, id: \.self) { day in
                let theme = ThemeProvider.theme(for: day)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(theme.closed.bgColor)
                    theme.closed.patternView
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Text("\(day)")
                        .font(.appFont(size: 20, weight: .bold))
                        .foregroundColor(theme.closed.textColor)
                }
                .frame(height: 60)
            }
        }
        .padding()
    }
    .appBackground()
}

#Preview("Opened Styles") {
    ScrollView {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
            ForEach(1...25, id: \.self) { day in
                let theme = ThemeProvider.theme(for: day)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(theme.opened.bgColor)
                    theme.opened.iconView(font: .title2)
                }
                .frame(height: 60)
            }
        }
        .padding()
    }
    .appBackground()
}
