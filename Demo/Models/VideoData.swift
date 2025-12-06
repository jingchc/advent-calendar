//
//  VideoData.swift
//  Demo
//
//  Created by JingChuang on 2025/12/6.
//

import Foundation

struct VideoData: Codable {
    let day: Int
    let title: String
    let videoURL: String

    enum CodingKeys: String, CodingKey {
        case day
        case title
        case videoURL = "video_url"
    }
}

struct VideoDataLoader {
    static func loadVideos() -> [VideoData] {
        guard let url = Bundle.main.url(forResource: "videos", withExtension: "json") else {
            return []
        }

        do {
            let data = try Data(contentsOf: url)
            let videos = try JSONDecoder().decode([VideoData].self, from: data)
            return videos
        } catch {
            return []
        }
    }
}
