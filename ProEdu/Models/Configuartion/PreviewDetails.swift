//
//  PreviewDetails.swift
//  ProEdu
//
//  Created by Raz  on 11/5/20.
//

import Foundation

struct PreviewDetails: Decodable {
    let dashboardVideo: DashboardVideo?
    
    enum CodingKeys: String, CodingKey {
        case dashboardVideo = "dashboard_video"
    }
}

struct DashboardVideo: Codable {
    let id: Int?
    let file, preview, createdAt, updatedAt: String?
    let title: String?

    enum CodingKeys: String, CodingKey {
        case id, file, preview
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case title
    }
}
