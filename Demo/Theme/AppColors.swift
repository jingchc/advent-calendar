//
//  AppColors.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import UIKit

// MARK: - UIColor Extension

extension UIColor {
    static let appBackground = UIColor(red: 0.96, green: 0.94, blue: 0.9, alpha: 1.0)
    static let christmasRed = UIColor(red: 0.6, green: 0.15, blue: 0.15, alpha: 1.0)
    static let forestGreen = UIColor(red: 0.2, green: 0.35, blue: 0.25, alpha: 1.0)
    static let darkGreen = UIColor(red: 0.15, green: 0.3, blue: 0.2, alpha: 1.0)
    static let cream = UIColor(red: 0.92, green: 0.85, blue: 0.70, alpha: 1.0)
    static let beige = UIColor(red: 0.85, green: 0.75, blue: 0.65, alpha: 1.0)
    static let warmBrown = UIColor(red: 0.55, green: 0.4, blue: 0.3, alpha: 1.0)
}

// MARK: - Color Extension

extension Color {
    static let appBackground = Color(uiColor: .appBackground)
    static let christmasRed = Color(uiColor: .christmasRed)
    static let forestGreen = Color(uiColor: .forestGreen)
    static let darkGreen = Color(uiColor: .darkGreen)
    static let cream = Color(uiColor: .cream)
    static let beige = Color(uiColor: .beige)
    static let warmBrown = Color(uiColor: .warmBrown)
}

// MARK: - Preview

#Preview("App Colors") {
    let colors: [(String, Color)] = [
        ("christmasRed", .christmasRed),
        ("forestGreen", .forestGreen),
        ("darkGreen", .darkGreen),
        ("cream", .cream),
        ("beige", .beige),
        ("warmBrown", .warmBrown)
    ]

    ScrollView {
        VStack(spacing: 12) {
            ForEach(colors, id: \.0) { name, color in
                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(color)
                        .frame(width: 60, height: 40)

                    Text(name)
                        .font(.appBody)
                        .foregroundColor(.forestGreen)

                    Spacer()
                }
            }
        }
        .padding()
    }
    .appBackground()
}
