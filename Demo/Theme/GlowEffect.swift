//
//  GlowEffect.swift
//  Demo
//
//  Created by JingChuang on 2025/12/13.
//

import SwiftUI

struct GlowEffect<S: Shape>: View {
    let shape: S
    var color: Color = .yellow.opacity(0.6)

    var body: some View {
        shape
            .fill(color)
            .phaseAnimator([false, true]) { view, phase in
                view
                    .blur(radius: phase ? 8 : 4)
                    .scaleEffect(phase ? 1.1 : 1.0)
            } animation: { _ in
                .easeInOut(duration: 1.0)
            }
    }
}

#Preview {
    VStack(spacing: 40) {
        GlowEffect(shape: RoundedRectangle(cornerRadius: 12))
            .frame(width: 100, height: 80)

        GlowEffect(shape: Circle(), color: .red.opacity(0.6))
            .frame(width: 80, height: 80)
    }
    .padding()
    .appBackground()
}
