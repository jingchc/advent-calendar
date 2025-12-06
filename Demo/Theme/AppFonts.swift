//
//  AppFonts.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import SwiftUI
import UIKit

// MARK: - Font Names

enum AppFontName {
    static let bold = ".AppleSystemUIFontRounded-Bold"
    static let light = ".AppleSystemUIFontRounded-Regular"
}

// MARK: - UIFont Extension

extension UIFont {
    static func appFont(size: CGFloat, bold: Bool = true) -> UIFont {
        let name = bold ? AppFontName.bold : AppFontName.light
        return UIFont(name: name, size: size) ?? .systemFont(ofSize: size)
    }
}

// MARK: - Font Extension

extension Font {
    static func appFont(size: CGFloat, weight: Font.Weight = .regular) -> Font {
        if weight == .light || weight == .ultraLight || weight == .thin {
            return .custom(AppFontName.light, size: size)
        }
        return .custom(AppFontName.bold, size: size)
    }

    static let appLargeTitle: Font = .custom(AppFontName.bold, size: 34)
    static let appTitle: Font = .custom(AppFontName.bold, size: 28)
    static let appTitle2: Font = .custom(AppFontName.bold, size: 22)
    static let appTitle3: Font = .custom(AppFontName.bold, size: 20)
    static let appHeadline: Font = .custom(AppFontName.bold, size: 17)
    static let appBody: Font = .custom(AppFontName.bold, size: 17)
    static let appCallout: Font = .custom(AppFontName.bold, size: 16)
    static let appSubheadline: Font = .custom(AppFontName.bold, size: 15)
    static let appFootnote: Font = .custom(AppFontName.bold, size: 13)
    static let appCaption: Font = .custom(AppFontName.light, size: 12)
    static let appCaption2: Font = .custom(AppFontName.light, size: 11)
}
