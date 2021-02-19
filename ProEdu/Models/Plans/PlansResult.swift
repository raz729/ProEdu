//
//  PlansResult.swift
//  ProEdu
//
//  Created by Raz  on 11/7/20.
//

import Foundation

class PlansResult: Decodable {
    let count: Int?
    let plans: [Plan]?
    
    enum CodingKeys: String, CodingKey {
        case count
        case plans = "results"
    }
}

class Plan: Decodable {
    let id: Int?
    let session: Session?
    let prices: [Price]?
    let stages: [PlanStage]?
    let video: PlanVideo?
    let title, shortDescription, fullDescription: String?

    enum CodingKeys: String, CodingKey {
        case id, session, prices, title
        case shortDescription = "short_description"
        case fullDescription = "full_description"
        case stages, video
    }
}

struct Price: Codable {
    let id: Int?
    let underAmount, title, priceDescription, period: String?
    let amount: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case underAmount = "under_amount"
        case title
        case priceDescription = "description"
        case period, amount
    }
}

struct PlanVideo: Decodable {
    let id: Int?
    let file: String?
    let preview: String?
    let duration: Int?
    let title: String?
    let category: String?
}

enum Period: String {
    case month = "month"
    case year = "year"
    case allTime = "all_time"
}

extension Period {
    var shortValue: String {
        switch self {
        case .month:
            return "мес."
        case .year:
            return "год"
        case .allTime:
            return ""
        }
    }
    
    var value: String {
        switch self {
        case .month:
            return "в месяц"
        case .year:
            return "12 месяцев"
        case .allTime:
            return "навсегда"
        }
    }
}
