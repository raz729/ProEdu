//
//  Stage.swift
//  ProEdu
//
//  Created by Raz  on 15.12.20.
//

import Foundation

struct PlanStage: Decodable {
    let id: Int?
    let order: Int?
    let title: String?
    var description: String?
    let minThreshold: Int?
    
    enum CodingKeys: String, CodingKey {
        case id, order, title, description
        case minThreshold = "min_threshold_to_change_stage"
    }
}
