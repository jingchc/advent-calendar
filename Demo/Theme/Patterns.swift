//
//  Patterns.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI

// MARK: - Pattern Views

struct DotsPattern: View {
    let color: Color

    var body: some View {
        Canvas { context, size in
            let dotSize: CGFloat = 4
            let spacing: CGFloat = 12
            for x in stride(from: spacing / 2, to: size.width, by: spacing) {
                for y in stride(from: spacing / 2, to: size.height, by: spacing) {
                    let rect = CGRect(x: x - dotSize / 2, y: y - dotSize / 2, width: dotSize, height: dotSize)
                    context.fill(Circle().path(in: rect), with: .color(color))
                }
            }
        }
    }
}

struct StripesPattern: View {
    let color: Color

    var body: some View {
        Canvas { context, size in
            let stripeWidth: CGFloat = 8
            let spacing: CGFloat = 16
            for x in stride(from: -size.height, to: size.width + size.height, by: spacing) {
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x + size.height, y: size.height))
                context.stroke(path, with: .color(color), lineWidth: stripeWidth)
            }
        }
    }
}

struct ZigzagPattern: View {
    let color: Color

    var body: some View {
        Canvas { context, size in
            let amplitude: CGFloat = 6
            let wavelength: CGFloat = 12
            let lineSpacing: CGFloat = 14

            for y in stride(from: amplitude, to: size.height + amplitude, by: lineSpacing) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                for x in stride(from: 0, to: size.width, by: wavelength) {
                    let nextX = x + wavelength / 2
                    let peakY = y - amplitude
                    path.addLine(to: CGPoint(x: nextX, y: peakY))
                    let valleyX = x + wavelength
                    path.addLine(to: CGPoint(x: valleyX, y: y))
                }
                context.stroke(path, with: .color(color), lineWidth: 2)
            }
        }
    }
}

struct DiamondsPattern: View {
    let color: Color

    var body: some View {
        Canvas { context, size in
            let diamondSize: CGFloat = 8
            let spacing: CGFloat = 16

            for x in stride(from: spacing / 2, to: size.width, by: spacing) {
                for y in stride(from: spacing / 2, to: size.height, by: spacing) {
                    var path = Path()
                    path.move(to: CGPoint(x: x, y: y - diamondSize / 2))
                    path.addLine(to: CGPoint(x: x + diamondSize / 2, y: y))
                    path.addLine(to: CGPoint(x: x, y: y + diamondSize / 2))
                    path.addLine(to: CGPoint(x: x - diamondSize / 2, y: y))
                    path.closeSubpath()
                    context.fill(path, with: .color(color))
                }
            }
        }
    }
}

// MARK: - Preview

#Preview("Patterns") {
    VStack(spacing: 20) {
        ForEach(["Dots", "Stripes", "Zigzag", "Diamonds"], id: \.self) { name in
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
                    .font(.caption)
                    .foregroundColor(.secondary)
                ZStack {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.christmasRed)
                    Group {
                        switch name {
                        case "Dots":
                            DotsPattern(color: .white.opacity(0.15))
                        case "Stripes":
                            StripesPattern(color: .white.opacity(0.15))
                        case "Zigzag":
                            ZigzagPattern(color: .white.opacity(0.15))
                        case "Diamonds":
                            DiamondsPattern(color: .white.opacity(0.15))
                        default:
                            EmptyView()
                        }
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .frame(height: 60)
            }
        }
    }
    .padding()
    .background(Color.appBackground)
}
