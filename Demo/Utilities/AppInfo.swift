//
//  AppInfo.swift
//  Demo
//
//  Created by JingChuang on 2025/12/13.
//

import Foundation

enum AppInfo {
    static var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    }

    static var build: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1"
    }

    static var displayVersion: String {
        "v\(version)"
    }

    static var fullVersion: String {
        "\(version) (\(build))"
    }
}
