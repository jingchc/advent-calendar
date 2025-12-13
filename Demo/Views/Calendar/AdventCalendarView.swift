//
//  AdventCalendarView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import SwiftData
import Dependencies

struct AdventCalendarView: View {
    @Query(sort: \AdventDay.day) private var adventDays: [AdventDay]
    @State private var viewModel = AdventCalendarViewModel()

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)

    var body: some View {
        ZStack {
            ScrollView {
                VStack(spacing: 40) {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(adventDays) { day in
                            AdventDayCell(day: day, isDebugMode: viewModel.isDebugMode)
                        }
                    }
                    .padding(.horizontal)

                    if viewModel.allOpened(days: adventDays) {
                        ChristmasBannerView()
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }

            if viewModel.isDebugMode {
                DebugPanelView(
                    allOpened: viewModel.allOpened(days: adventDays),
                    allFavorite: viewModel.allFavorite(days: adventDays),
                    onToggleOpen: { viewModel.toggleAllOpen(days: adventDays) },
                    onToggleFavorite: { viewModel.toggleAllFavorite(days: adventDays) }
                )
            }
        }
        .appBackground()
        .navigationTitle("Advent Calendar")
        .safeAreaInset(edge: .bottom) {
            Text(AppInfo.displayVersion)
                .font(.appCaption2)
                .foregroundColor(.secondary.opacity(0.5))
                .frame(maxWidth: .infinity)
                .padding(.bottom, 4)
                .onTapGesture {
                    withAnimation {
                        viewModel.handleVersionTap()
                    }
                }
        }
        .onChange(of: viewModel.allOpened(days: adventDays)) { _, _ in
            viewModel.checkCelebration(days: adventDays)
        }
        .fullScreenCover(isPresented: Binding(
            get: { viewModel.showCelebration },
            set: { _ in viewModel.dismissCelebration() }
        )) {
            ChristmasCelebrationView()
        }
    }
}

#Preview {
    withDependencies {
        $0.database = .previewValue
    } operation: {
        @Dependency(\.database) var database
        return NavigationStack {
            AdventCalendarView()
        }
        .modelContainer(database.container)
    }
}

#Preview("With Banner") {
    withDependencies {
        $0.database = .previewValue
    } operation: {
        @Dependency(\.database) var database
        database.openAllDays()
        return NavigationStack {
            AdventCalendarView()
        }
        .modelContainer(database.container)
    }
}
