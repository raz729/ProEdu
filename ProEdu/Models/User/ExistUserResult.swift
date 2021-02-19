//
//  ExistUserResult.swift
//  ProEdu
//
//  Created by Raz  on 11/6/20.
//

import Foundation

struct ExistUserResult: Decodable {
    let phoneNumber: String?
    let isExist: Bool?
    let confirmed: Bool?
    
    enum CodingKeys: String, CodingKey {
        case isExist = "exist"
        case confirmed
        case phoneNumber = "phone_number"
    }
}
