//
//  VerificationModel.swift
//  ProEdu
//
//  Created by Raz  on 11/5/20.
//

import Foundation

class VerificationModel {
    
    var duration: TimeInterval = 120
    var codeDigits: [Int] = []
    var securityCode: String {
        return (codeDigits.map{String($0)}).joined(separator: "")
    }
    
    var phoneNumber: String = ""
    var sessionToken: String?
    var isUserExist: Bool = false
    var confirmed: Bool = false
    var name: String = ""
    var token: String?
    
    func resetDuration() {
        duration = 120
    }
}
