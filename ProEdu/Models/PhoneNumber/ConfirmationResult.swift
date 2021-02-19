//
//  ConfirmationResult.swift
//  ProEdu
//
//  Created by Raz  on 11/5/20.
//

import Foundation

struct ConfirmationResult: Decodable {
    let access, refresh: String?
    
    enum CodeingKeys: String, CodingKey {
        case access, refresh
    }
}
