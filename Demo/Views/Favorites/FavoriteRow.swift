//
//  FavoriteRow.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI

struct FavoriteRow: View {
    @Bindable var day: AdventDay

    private var theme: DayTheme {
        ThemeProvider.theme(for: day.day)
    }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(theme.opened.bgColor)
                    .frame(width: 50, height: 50)

                theme.opened.iconView(font: .appTitle2)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(day.title)
                    .font(.appHeadline)
                    .foregroundColor(.forestGreen)

                if let openedAt = day.openedAt {
                    Text("Opened: \(openedAt.formatted(date: .abbreviated, time: .shortened))")
                        .font(.appCaption)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()

            Button {
                day.isFavorite = false
            } label: {
                Image(systemName: "heart.fill")
                    .foregroundColor(.christmasRed)
                    .font(.appTitle3)
            }
            .buttonStyle(.plain)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    let day = AdventDay(day: 5, videoURL: "", title: "Day 5 Surprise")
    day.isOpened = true
    day.openedAt = Date()
    day.isFavorite = true

    return FavoriteRow(day: day)
        .padding()
        .appBackground()
}
