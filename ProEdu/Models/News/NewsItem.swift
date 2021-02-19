//
//  NewsItem.swift
//  ProEdu
//
//  Created by Raz  on 24.11.20.
//

import Foundation

struct NewsItems: Codable {
    let count: Int?
    let next, previous: String?
    let news: [News]?
    
    enum CodingKeys: String, CodingKey {
        case count, next, previous
        case news = "results"
    }
}

struct News: Codable {
    let id: Int?
    let video: Video?
    let createdAt, updatedAt, title, subtitle: String?
    let category: String?

    enum CodingKeys: String, CodingKey {
        case id, video
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case title, subtitle, category
    }
}

struct Video: Codable {
    let id: Int?
    let file, preview: String?
    let duration: Int?
    let title, category: String?
}
