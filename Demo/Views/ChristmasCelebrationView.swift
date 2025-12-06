//
//  ChristmasCelebrationView.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI

struct ChristmasCelebrationView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var titleScale: CGFloat = 0.5
    @State private var titleOpacity: Double = 0
    @State private var messageOpacity: Double = 0
    @State private var snowflakes: [Snowflake] = []
    @State private var showSparkles = false

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

                // Sparkles
                if showSparkles {
                    ForEach(0..<20, id: \.self) { i in
                        SparkleView(delay: Double(i) * 0.1)
                            .position(
                                x: CGFloat.random(in: 50...geometry.size.width - 50),
                                y: CGFloat.random(in: 200...geometry.size.height - 200)
                            )
                    }
                }

                VStack(spacing: 30) {
                    Spacer()

                    // Christmas tree emoji
                    Text("🎄")
                        .font(.system(size: 80))
                        .scaleEffect(titleScale)

                    // Title
                    Text("Merry Christmas!")
                        .font(.appFont(size: 36, weight: .bold))
                        .foregroundColor(.cream)
                        .scaleEffect(titleScale)
                        .opacity(titleOpacity)

                    // Blessing messages
                    VStack(spacing: 16) {
                        Text("🎁 願你的聖誕充滿愛與歡樂 🎁")
                        Text("✨ May your holidays be magical ✨")
                        Text("🌟 Wishing you peace and joy 🌟")
                    }
                    .font(.appFont(size: 18, weight: .regular))
                    .foregroundColor(.cream.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .opacity(messageOpacity)

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
                    .opacity(messageOpacity)
                    .padding(.bottom, 50)
                }
                .padding()
            }
        }
        .onAppear {
            startAnimations()
        }
    }

    private func startAnimations() {
        // Generate snowflakes (positions are used as offsets for continuous falling)
        snowflakes = (0..<30).map { _ in
            Snowflake(
                x: CGFloat.random(in: 20...380),
                y: CGFloat.random(in: 0...800),
                size: CGFloat.random(in: 15...30),
                opacity: Double.random(in: 0.4...0.9)
            )
        }

        // Title animation
        withAnimation(.spring(response: 0.8, dampingFraction: 0.6).delay(0.3)) {
            titleScale = 1.0
            titleOpacity = 1.0
        }

        // Message animation
        withAnimation(.easeOut(duration: 0.8).delay(0.8)) {
            messageOpacity = 1.0
        }

        // Sparkles
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            showSparkles = true
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
