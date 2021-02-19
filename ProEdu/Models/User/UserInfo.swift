//
//  UserInfo.swift
//  ProEdu
//
//  Created by Raz  on 11/5/20.
//

import Foundation

struct UserInfo: Codable {
    
    var id: Int?
    var avatar: String?
    var permissions: Permissions?
    var lastLogin, createdAt, updatedAt, firstName: String?
    var lastName, phone, email: String?
    var phoneVerified: Bool?
    var lastActivity: String?
    
    enum CodingKeys: String, CodingKey {
        case id, avatar, permissions
        case lastLogin = "last_login"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case phone, email
        case phoneVerified = "phone_verified"
        case lastActivity = "last_activity"
    }
}
