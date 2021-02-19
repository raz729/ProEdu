//
//  PlanModel.swift
//  ProEdu
//
//  Created by Raz  on 11/1/20.
//

import Foundation

struct PlanModel: Codable {
    let title: String?
    let description: String?
    let price: String?
    var isPurchased: Bool = false
}
