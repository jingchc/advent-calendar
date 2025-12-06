//
//  CellStyles.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI

enum PatternType {
    case dots, stripes, zigzag, diamonds
}

struct CellStyle {
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

struct CellStyles {
    static func cellStyle(for day: Int) -> CellStyle {
        let styles: [CellStyle] = [
            CellStyle(bgColor: .christmasRed, textColor: .white, pattern: .zigzag),
            CellStyle(bgColor: .cream, textColor: .warmBrown, pattern: .dots),
            CellStyle(bgColor: .christmasRed, textColor: .cream, pattern: .stripes),
            CellStyle(bgColor: .forestGreen, textColor: .white, pattern: .diamonds),
            CellStyle(bgColor: .beige, textColor: .warmBrown, pattern: .stripes),
            CellStyle(bgColor: .darkGreen, textColor: .white, pattern: .dots),
            CellStyle(bgColor: .cream, textColor: .christmasRed, pattern: .zigzag),
            CellStyle(bgColor: .christmasRed, textColor: .white, pattern: .dots),
            CellStyle(bgColor: .beige, textColor: .warmBrown, pattern: .diamonds),
            CellStyle(bgColor: .forestGreen, textColor: .cream, pattern: .zigzag),
            CellStyle(bgColor: .warmBrown, textColor: .cream, pattern: .stripes),
            CellStyle(bgColor: .cream, textColor: .forestGreen, pattern: .diamonds),
            CellStyle(bgColor: .christmasRed, textColor: .cream, pattern: .zigzag),
            CellStyle(bgColor: .beige, textColor: .christmasRed, pattern: .dots),
            CellStyle(bgColor: .darkGreen, textColor: .white, pattern: .diamonds),
            CellStyle(bgColor: .cream, textColor: .warmBrown, pattern: .stripes),
            CellStyle(bgColor: .forestGreen, textColor: .white, pattern: .zigzag),
            CellStyle(bgColor: .christmasRed, textColor: .white, pattern: .diamonds),
            CellStyle(bgColor: .beige, textColor: .forestGreen, pattern: .dots),
            CellStyle(bgColor: .darkGreen, textColor: .cream, pattern: .stripes),
            CellStyle(bgColor: .warmBrown, textColor: .white, pattern: .diamonds),
            CellStyle(bgColor: .cream, textColor: .christmasRed, pattern: .zigzag),
            CellStyle(bgColor: .forestGreen, textColor: .cream, pattern: .zigzag),
            CellStyle(bgColor: .christmasRed, textColor: .white, pattern: .stripes),
            CellStyle(bgColor: .darkGreen, textColor: .white, pattern: .dots)
        ]
        let index = (day - 1) % styles.count
        return styles[index]
    }

    static func openedStyle(for day: Int) -> OpenedStyle {
        let styles: [OpenedStyle] = [
            OpenedStyle(icon: "gift.fill", bgColor: .christmasRed, iconColor: .cream),
            OpenedStyle(icon: "🎄", bgColor: .cream, iconColor: .forestGreen),
            OpenedStyle(icon: "bell.fill", bgColor: .forestGreen, iconColor: .white),
            OpenedStyle(icon: "star.fill", bgColor: .beige, iconColor: .christmasRed),
            OpenedStyle(icon: "heart.fill", bgColor: .christmasRed, iconColor: .white),
            OpenedStyle(icon: "snowflake", bgColor: .darkGreen, iconColor: .white),
            OpenedStyle(icon: "sparkles", bgColor: .cream, iconColor: .christmasRed),
            OpenedStyle(icon: "moon.stars.fill", bgColor: .forestGreen, iconColor: .cream),
            OpenedStyle(icon: "☕️", bgColor: .warmBrown, iconColor: .cream),
            OpenedStyle(icon: "house.fill", bgColor: .beige, iconColor: .forestGreen),
            OpenedStyle(icon: "music.note", bgColor: .christmasRed, iconColor: .white),
            OpenedStyle(icon: "🌈", bgColor: .forestGreen, iconColor: .cream),
            OpenedStyle(icon: "flame.fill", bgColor: .christmasRed, iconColor: .orange),
            OpenedStyle(icon: "🐱", bgColor: .cream, iconColor: .forestGreen),
            OpenedStyle(icon: "⛄️", bgColor: .darkGreen, iconColor: .white),
            OpenedStyle(icon: "crown.fill", bgColor: .beige, iconColor: .christmasRed),
            OpenedStyle(icon: "fireworks", bgColor: .christmasRed, iconColor: .cream),
            OpenedStyle(icon: "hands.clap.fill", bgColor: .warmBrown, iconColor: .white),
            OpenedStyle(icon: "party.popper.fill", bgColor: .forestGreen, iconColor: .white),
            OpenedStyle(icon: "book.fill", bgColor: .beige, iconColor: .warmBrown),
            OpenedStyle(icon: "🏆", bgColor: .cream, iconColor: .white),
            OpenedStyle(icon: "sun.max.fill", bgColor: .christmasRed, iconColor: .yellow),
            OpenedStyle(icon: "🕊️", bgColor: .forestGreen, iconColor: .white),
            OpenedStyle(icon: "wand.and.stars", bgColor: .darkGreen, iconColor: .white),
            OpenedStyle(icon: "🎅🏻", bgColor: .christmasRed, iconColor: .white)
        ]
        let index = (day - 1) % styles.count
        return styles[index]
    }
}

// MARK: - Preview

#Preview("Cell Styles") {
    ScrollView {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
            ForEach(1...25, id: \.self) { day in
                let style = CellStyles.cellStyle(for: day)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(style.bgColor)
                    style.patternView
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    Text("\(day)")
                        .font(.appFont(size: 20, weight: .bold))
                        .foregroundColor(style.textColor)
                }
                .frame(height: 60)
            }
        }
        .padding()
    }
    .background(Color.appBackground)
}

#Preview("Opened Styles") {
    ScrollView {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 5), spacing: 8) {
            ForEach(1...25, id: \.self) { day in
                let style = CellStyles.openedStyle(for: day)
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(style.bgColor)
                    style.iconView(font: .title2)
                }
                .frame(height: 60)
            }
        }
        .padding()
    }
    .background(Color.appBackground)
}
