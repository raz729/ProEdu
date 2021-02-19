//
//  Session.swift
//  ProEdu
//
//  Created by Raz  on 15.12.20.
//

import Foundation

struct Session: Decodable {
    let id: Int?
    let currentStage: CurrentStage?
    let currentWeek: CurrentWeek?
    let isActive: Bool?
//    let createdAt, expireAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case currentStage = "current_stage"
        case currentWeek = "current_week"
        case isActive = "is_active"
//        case createdAt = "created_at"
//        case expireAt = "expire_at"
    }
}

struct Stage: Decodable {
    let id: Int?
    let order: Int?
    let title: String?
    let description: String?
    let minThresholdToChangeStage: Int?

    enum CodingKeys: String, CodingKey {
        case id, order, title, description
        case minThresholdToChangeStage = "min_threshold_to_change_stage"
    }
}

struct CurrentStage: Decodable {
    let id: Int?
    let progress: Progress
    let canGoForward: Bool
    let stage: Stage?
    let isActive: Bool?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, progress
        case canGoForward = "can_go_forward"
        case stage
        case isActive = "is_active"
        case createdAt = "created_at"
    }
}

struct CurrentWeek: Decodable {
    let id: Int?
    let progress: Progress?
    let isActive: Bool?
    let createdAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, progress
        case isActive = "is_active"
        case createdAt = "created_at"
    }
}

struct Progress: Codable {
    let current, max, threshold: Int?
}
