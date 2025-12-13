//
//  GiftOpeningView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI

struct GiftOpeningView: View {
    let day: AdventDay
    let onComplete: () -> Void

    @State private var lidOffset: CGFloat = 0
    @State private var lidRotation: Double = 0
    @State private var boxScale: CGFloat = 1.0
    @State private var showSparkles = false
    @State private var iconScale: CGFloat = 0.3
    @State private var iconOpacity: Double = 0
    @State private var iconOffset: CGFloat = 50

    private var theme: DayTheme {
        ThemeProvider.theme(for: day.day)
    }

    var body: some View {
        ZStack {
            // Sparkles
            if showSparkles {
                SparklesView()
            }

            // Gift Box
            VStack(spacing: 0) {
                // Lid
                GiftLidView(color: theme.opened.bgColor, ribbonColor: theme.opened.iconColor)
                    .offset(y: lidOffset)
                    .rotationEffect(.degrees(lidRotation), anchor: .leading)

                // Box body
                GiftBoxView(color: theme.opened.bgColor, ribbonColor: theme.opened.iconColor)
            }
            .scaleEffect(boxScale)

            // Icon reveal - flies up from box
            theme.opened.iconView(font: .system(size: 80))
                .shadow(color: .black.opacity(0.3), radius: 4, x: 0, y: 2)
                .scaleEffect(iconScale)
                .opacity(iconOpacity)
                .offset(y: iconOffset)
        }
        .appBackground()
        .onAppear {
            startAnimation()
        }
    }

    private func startAnimation() {
        // Phase 1: Box shakes
        withAnimation(.easeInOut(duration: 0.1).repeatCount(4)) {
            boxScale = 1.05
        }

        // Phase 2: Lid opens
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                lidOffset = -60
                lidRotation = -45
                showSparkles = true
            }
        }

        // Phase 3: Icon flies up from box
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.6)) {
                iconScale = 1.0
                iconOpacity = 1.0
                iconOffset = -80
            }
        }

        // Phase 4: Transition to video
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.3)) {
                boxScale = 0.5
                iconScale = 1.5
                iconOpacity = 0
                iconOffset = -150
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.8) {
            onComplete()
        }
    }
}

// MARK: - Gift Components

struct GiftLidView: View {
    let color: Color
    let ribbonColor: Color

    var body: some View {
        ZStack {
            // Lid top
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 140, height: 30)

            // Ribbon on top
            RoundedRectangle(cornerRadius: 4)
                .fill(ribbonColor)
                .frame(width: 30, height: 30)

            // Bow
            Circle()
                .fill(ribbonColor.opacity(0.8))
                .frame(width: 24, height: 24)
        }
    }
}

struct GiftBoxView: View {
    let color: Color
    let ribbonColor: Color

    var body: some View {
        ZStack {
            // Box body
            RoundedRectangle(cornerRadius: 8)
                .fill(color)
                .frame(width: 120, height: 100)

            // Vertical ribbon
            Rectangle()
                .fill(ribbonColor)
                .frame(width: 20, height: 100)
        }
    }
}

struct SparklesView: View {
    @State private var sparkles: [(id: Int, x: CGFloat, y: CGFloat, delay: Double)] = []

    var body: some View {
        ZStack {
            ForEach(sparkles, id: \.id) { sparkle in
                SparkleView(delay: sparkle.delay)
                    .position(x: sparkle.x, y: sparkle.y)
            }
        }
        .onAppear {
            generateSparkles()
        }
    }

    private func generateSparkles() {
        sparkles = (0..<12).map { i in
            (
                id: i,
                x: CGFloat.random(in: 50...350),
                y: CGFloat.random(in: 200...600),
                delay: Double.random(in: 0...0.3)
            )
        }
    }
}

struct SparkleView: View {
    let delay: Double
    @State private var scale: CGFloat = 0
    @State private var opacity: Double = 0
    @State private var rotation: Double = 0

    var body: some View {
        Image(systemName: "sparkle")
            .font(.title)
            .foregroundColor(.yellow)
            .scaleEffect(scale)
            .opacity(opacity)
            .rotationEffect(.degrees(rotation))
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                    withAnimation(.easeOut(duration: 0.4)) {
                        scale = 1.0
                        opacity = 1.0
                        rotation = 20
                    }
                    withAnimation(.easeIn(duration: 0.3).delay(0.5)) {
                        scale = 0
                        opacity = 0
                    }
                }
            }
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State private var key = UUID()

        var body: some View {
            GiftOpeningView(
                day: AdventDay(day: 1, videoURL: "", title: "Day 1"),
                onComplete: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        key = UUID()
                    }
                }
            )
            .id(key)
        }
    }

    return PreviewWrapper()
}
