//
//  AppBackground.swift
//  Demo
//
//  Created by JingChuang on 2025/12/13.
//

import SwiftUI

struct AppBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Color.appBackground.ignoresSafeArea()
            content
        }
    }
}

extension View {
    func appBackground() -> some View {
        modifier(AppBackgroundModifier())
    }
}
