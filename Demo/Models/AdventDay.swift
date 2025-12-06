//
//  AdventDay.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import Foundation
import SwiftData

@Model
final class AdventDay {
    @Attribute(.unique) var day: Int
    var videoURL: String
    var title: String
    var isOpened: Bool
    var openedAt: Date?
    var isFavorite: Bool

    init(day: Int, videoURL: String, title: String = "", isOpened: Bool = false, openedAt: Date? = nil, isFavorite: Bool = false) {
        self.day = day
        self.videoURL = videoURL
        self.title = title
        self.isOpened = isOpened
        self.openedAt = openedAt
        self.isFavorite = isFavorite
    }
}
