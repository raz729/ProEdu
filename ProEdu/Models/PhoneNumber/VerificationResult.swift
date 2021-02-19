//
//  VerificationResult.swift
//  ProEdu
//
//  Created by Raz  on 11/5/20.
//

import Foundation

struct VerificationResult: Decodable {
    var sessionToken: String?
    
    enum CodingKeys: String, CodingKey {
        case sessionToken = "session_token"
    }
}
