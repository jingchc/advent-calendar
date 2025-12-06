//
//  ChristmasBannerView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI

struct ChristmasBannerView: View {
    @State private var isAnimating = false

    var body: some View {
        HStack(spacing: 12) {
            Text("🎄")
                .font(.title)
                .scaleEffect(isAnimating ? 1.1 : 1.0)

            VStack(spacing: 2) {
                Text("Merry Christmas!")
                    .font(.appFont(size: 18, weight: .bold))
                    .foregroundColor(.cream)
                Text("恭喜完成所有驚喜")
                    .font(.appFont(size: 12, weight: .regular))
                    .foregroundColor(.cream.opacity(0.9))
            }

            Text("🎅🏻")
                .font(.title)
                .scaleEffect(isAnimating ? 1.1 : 1.0)
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 16)
        .background(
            LinearGradient(
                colors: [.christmasRed, .christmasRed.opacity(0.8)],
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 2)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.0).repeatForever(autoreverses: true)) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    ChristmasBannerView()
        .padding()
        .background(Color.appBackground)
}
