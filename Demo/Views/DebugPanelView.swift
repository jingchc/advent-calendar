//
//  DebugPanelView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI

struct DebugPanelView: View {
    var allOpened: Bool
    var allFavorite: Bool
    var onToggleOpen: () -> Void
    var onToggleFavorite: () -> Void

    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 12) {
                Button {
                    onToggleOpen()
                } label: {
                    Image(systemName: allOpened ? "xmark.circle.fill" : "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(allOpened ? Color.red : Color.blue)
                        .clipShape(Circle())
                }

                Button {
                    onToggleFavorite()
                } label: {
                    Image(systemName: allFavorite ? "heart.fill" : "heart.slash.fill")
                        .font(.title3)
                        .foregroundColor(.white)
                        .frame(width: 44, height: 44)
                        .background(allFavorite ? Color.christmasRed : Color.gray)
                        .clipShape(Circle())
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .clipShape(Capsule())
            .shadow(radius: 5)
            .padding(.bottom, 20)
        }
    }
}

#Preview {
    ZStack {
        Color.appBackground.ignoresSafeArea()
        DebugPanelView(
            allOpened: false,
            allFavorite: false,
            onToggleOpen: {},
            onToggleFavorite: {}
        )
    }
}
