//
//  FavoritesView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Query(filter: #Predicate<AdventDay> { $0.isFavorite }, sort: \AdventDay.day)
    private var favorites: [AdventDay]
    @State private var selectedDay: AdventDay?

    var body: some View {
        Group {
            if favorites.isEmpty {
                ContentUnavailableView {
                    Label("No Favorites Yet", systemImage: "heart")
                        .font(.appTitle2)
                } description: {
                    Text("Tap the heart icon while watching a video to add it to your favorites.")
                        .font(.appBody)
                }
                .background(Color.appBackground)
            } else {
                List(favorites) { day in
                    FavoriteRow(day: day)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selectedDay = day
                        }
                        .listRowBackground(Color.appBackground)
                }
                .scrollContentBackground(.hidden)
                .background(Color.appBackground)
            }
        }
        .navigationTitle("Favorites")
        .fullScreenCover(item: $selectedDay) { day in
            VideoPlayerView(day: day)
        }
    }
}

struct FavoriteRow: View {
    @Bindable var day: AdventDay

    private var style: OpenedStyle {
        CellStyles.openedStyle(for: day.day)
    }

    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(style.bgColor)
                    .frame(width: 50, height: 50)

                style.iconView(font: .appTitle2)
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

#Preview("Empty") {
    NavigationStack {
        FavoritesView()
    }
    .modelContainer(for: AdventDay.self, inMemory: true)
}

#Preview("With Favorites") {
    let container = try! ModelContainer(for: AdventDay.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))

    for day in [1, 3, 6, 12, 25] {
        let adventDay = AdventDay(
            day: day,
            videoURL: "https://example.com/video.mp4",
            title: "Day \(day) Surprise"
        )
        adventDay.isOpened = true
        adventDay.openedAt = Date()
        adventDay.isFavorite = true
        container.mainContext.insert(adventDay)
    }

    return NavigationStack {
        FavoritesView()
    }
    .modelContainer(container)
}
