//
//  AdventCalendarView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import SwiftData

struct AdventCalendarView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \AdventDay.day) private var adventDays: [AdventDay]
    @State private var isDebugMode = false
    @State private var tapCount = 0
    @State private var showCelebration = false
    @State private var hasShownCelebration = false

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)

    private var allOpened: Bool {
        adventDays.allSatisfy { $0.isOpened }
    }

    private var allFavorite: Bool {
        adventDays.allSatisfy { $0.isFavorite }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    VStack(spacing: 40) {
                        LazyVGrid(columns: columns, spacing: 10) {
                            ForEach(adventDays) { day in
                                AdventDayCell(day: day, isDebugMode: isDebugMode)
                            }
                        }
                        .padding(.horizontal)

                        // Christmas banner when all opened
                        if allOpened && adventDays.count == 25 {
                            ChristmasBannerView()
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                }
                .background(Color.appBackground)

                if isDebugMode {
                    DebugPanelView(
                        allOpened: allOpened,
                        allFavorite: allFavorite,
                        onToggleOpen: {
                            if allOpened {
                                resetAllDays()
                            } else {
                                openAllDays()
                            }
                        },
                        onToggleFavorite: {
                            if allFavorite {
                                unfavoriteAll()
                            } else {
                                favoriteAll()
                            }
                        }
                    )
                }
            }
            .navigationTitle("Advent Calendar")
            .safeAreaInset(edge: .bottom) {
                Text("v\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")")
                    .font(.appCaption2)
                    .foregroundColor(.secondary.opacity(0.5))
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 4)
                    .onTapGesture {
                        tapCount += 1
                        if tapCount >= 5 {
                            withAnimation {
                                isDebugMode.toggle()
                            }
                            tapCount = 0
                        }
                    }
            }
            .onAppear {
                seedDataIfNeeded()
            }
            .onChange(of: allOpened) { _, isAllOpened in
                if isAllOpened && !hasShownCelebration && adventDays.count == 25 {
                    hasShownCelebration = true
                    showCelebration = true
                }
            }
            .fullScreenCover(isPresented: $showCelebration) {
                ChristmasCelebrationView()
            }
        }
    }

    private func resetAllDays() {
        for day in adventDays {
            day.isOpened = false
            day.openedAt = nil
        }
    }

    private func openAllDays() {
        for day in adventDays {
            if !day.isOpened {
                day.isOpened = true
                day.openedAt = Date()
            }
        }
    }

    private func favoriteAll() {
        for day in adventDays {
            day.isFavorite = true
        }
    }

    private func unfavoriteAll() {
        for day in adventDays {
            day.isFavorite = false
        }
    }

    private func seedDataIfNeeded() {
        guard adventDays.isEmpty else { return }

        let videos = VideoDataLoader.loadVideos()
        for video in videos {
            let adventDay = AdventDay(
                day: video.day,
                videoURL: video.videoURL,
                title: video.title
            )
            modelContext.insert(adventDay)
        }
    }
}

#Preview {
    AdventCalendarView()
        .modelContainer(for: AdventDay.self, inMemory: true)
}

#Preview("With Banner") {
    let container = try! ModelContainer(
        for: AdventDay.self,
        configurations: ModelConfiguration(isStoredInMemoryOnly: true)
    )

    for day in 1...25 {
        let adventDay = AdventDay(
            day: day,
            videoURL: "https://example.com/video.mp4",
            title: "Day \(day) Surprise"
        )
        adventDay.isOpened = true
        adventDay.openedAt = Date()
        container.mainContext.insert(adventDay)
    }

    return AdventCalendarView()
        .modelContainer(container)
}
