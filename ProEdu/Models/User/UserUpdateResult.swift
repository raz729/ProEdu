//
//  UserUpdateResult.swift
//  ProEdu
//
//  Created by Raz  on 11/5/20.
//

import Foundation

struct UserUpdateResult: Decodable {
    let id: Int?
    let avatar: String?
    let permissions: Permissions?
    let lastLogin, createdAt, updatedAt, firstName: String?
    let lastName, phone, email: String?
    let phoneVerified: Bool?
    let lastActivity: String?

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

// MARK: - Permissions
struct Permissions: Codable {
    let isSuperuser, isStaff: Bool?

    enum CodingKeys: String, CodingKey {
        case isSuperuser = "is_superuser"
        case isStaff = "is_staff"
    }
}
