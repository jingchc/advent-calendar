//
//  ChristmasCelebrationView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI

struct ChristmasCelebrationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var isAnimated = false
    @State private var snowflakes: [Snowflake] = []
    @State private var sparklePositions: [CGPoint] = []

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Background
                LinearGradient(
                    colors: [.darkGreen, .forestGreen],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                // Snowflakes
                TimelineView(.animation) { timeline in
                    Canvas { context, size in
                        let now = timeline.date.timeIntervalSinceReferenceDate
                        for flake in snowflakes {
                            let fallSpeed = 50.0 + Double(flake.size)
                            let cycleY = (now * fallSpeed + Double(flake.y)).truncatingRemainder(dividingBy: Double(size.height + 100))
                            let swayX = sin(now * 2 + Double(flake.x) * 0.1) * 20

                            context.opacity = flake.opacity
                            let point = CGPoint(x: flake.x + swayX, y: cycleY - 50)
                            context.draw(Text("❄️").font(.system(size: flake.size)), at: point)
                        }
                    }
                }
                .ignoresSafeArea()

                // Sparkles
                ForEach(sparklePositions.indices, id: \.self) { i in
                    SparkleView(delay: Double(i) * 0.1)
                        .position(sparklePositions[i])
                }
                .ignoresSafeArea()

                VStack(spacing: 30) {
                    Spacer()

                    // Christmas tree emoji
                    Text("🎄")
                        .font(.system(size: 80))
                        .scaleEffect(isAnimated ? 1.0 : 0.5)

                    // Title
                    Text("Merry Christmas!")
                        .font(.appFont(size: 36, weight: .bold))
                        .foregroundColor(.cream)
                        .scaleEffect(isAnimated ? 1.0 : 0.5)
                        .opacity(isAnimated ? 1.0 : 0)

                    // Blessing messages
                    VStack(spacing: 16) {
                        Text("🎁 願你的聖誕充滿愛與歡樂 🎁")
                        Text("✨ May your holidays be magical ✨")
                        Text("🌟 Wishing you peace and joy 🌟")
                    }
                    .font(.appFont(size: 18, weight: .regular))
                    .foregroundColor(.cream.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .opacity(isAnimated ? 1.0 : 0)

                    Spacer()

                    // Close button
                    Button {
                        dismiss()
                    } label: {
                        Text("🎅🏻 感謝你的陪伴 🎅🏻")
                            .font(.appHeadline)
                            .foregroundColor(.forestGreen)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.cream)
                            .clipShape(Capsule())
                    }
                    .opacity(isAnimated ? 1.0 : 0)
                    .padding(.bottom, 50)
                }
                .padding()
            }
            .onAppear {
                setupAnimations(in: geometry.size)
            }
        }
    }

    private func setupAnimations(in size: CGSize) {
        // Generate snowflakes (y is random offset for staggered start)
        snowflakes = (0..<30).map { _ in
            Snowflake(
                x: CGFloat.random(in: 0...size.width),
                y: CGFloat.random(in: 0...size.height + 100),
                size: CGFloat.random(in: 15...30),
                opacity: Double.random(in: 0.4...0.9)
            )
        }

        // Generate sparkle positions once
        sparklePositions = (0..<20).map { _ in
            CGPoint(
                x: CGFloat.random(in: 50...size.width - 50),
                y: CGFloat.random(in: 50...size.height - 50)
            )
        }

        // Single animation trigger
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3)) {
            isAnimated = true
        }
    }
}

struct Snowflake: Identifiable {
    let id = UUID()
    var x: CGFloat
    var y: CGFloat
    var size: CGFloat
    var opacity: Double
}

#Preview {
    ChristmasCelebrationView()
}
