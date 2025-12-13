//
//  DateProvider.swift
//  Demo
//
//  Created by JingChuang on 2025/12/13.
//

import Foundation
import Dependencies

struct DateProvider: Sendable {
    var now: @Sendable () -> Date
}

extension DateProvider: DependencyKey {
    static let liveValue = DateProvider(now: { Date() })
    static let previewValue = DateProvider(now: { Date() })
    static let testValue = DateProvider(now: { Date() })
}

extension DependencyValues {
    var date: DateProvider {
        get { self[DateProvider.self] }
        set { self[DateProvider.self] = newValue }
    }
}

// MARK: - Convenience

extension DateProvider {
    static func fixed(month: Int = 12, day: Int, year: Int? = nil) -> DateProvider {
        DateProvider(now: {
            let y = year ?? Calendar.current.component(.year, from: Date())
            return Calendar.current.date(from: DateComponents(year: y, month: month, day: day))!
        })
    }
}
