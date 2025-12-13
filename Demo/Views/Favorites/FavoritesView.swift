//
//  FavoritesView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import SwiftData
import Dependencies

struct FavoritesView: View {
    @Query(filter: #Predicate<AdventDay> { $0.isFavorite }, sort: \AdventDay.day)
    private var favorites: [AdventDay]
    @Dependency(\.router) var router

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
            } else {
                List(favorites) { day in
                    FavoriteRow(day: day)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            router.push(.video(day), from: .favorites)
                        }
                        .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .appBackground()
        .navigationTitle("Favorites")
    }
}

#Preview("Empty") {
    withDependencies {
        $0.database = .previewValue
    } operation: {
        @Dependency(\.database) var database
        return NavigationStack {
            FavoritesView()
        }
        .modelContainer(database.container)
    }
}

#Preview("With Favorites") {
    withDependencies {
        $0.database = .previewValue
    } operation: {
        @Dependency(\.database) var database
        database.markFavorites()
        return NavigationStack {
            FavoritesView()
        }
        .modelContainer(database.container)
    }
}
