//
//  ApiTarget.swift
//  ProEdu
//
//  Created by Raz  on 11/5/20.
//

import Foundation

enum APIServiceMethod {
    
    // MARK: - Configuration
    case getPreviewDetails
    
    // MARK: - Users
    case phoneVerification(_ phoneNumber: String)
    case phoneConfirmation(_ phoneNumber: String, _ sessionToken: String, _ securityCode: String)
    case isUserExists(_ phoneNumber: String)
    case getSecureCode(_ phoneNumber: String)
    case updateUserInfo(_ userInfo: UserInfo)
    case getUserInfo
    case updateAvatar
    
    // MARK: - Plans
    case getPlans
    case buyPlan
    case getSession(_ id: Int)
    case getProducts(_ id: Int)
    case activateSession(_ id: Int)
    
    // MARK: - News
    case getNewsCategories
    case getNews
    
    
//    //MARK: - Stages
//    case getStage
//    case getProducts
//    case stageForward
}

extension APIServiceMethod {
    
    var jsonEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        return encoder
    }
    
    var path: String {
        switch self {
        
        // MARK: - Configuration
        case .getPreviewDetails:
            return "common/configuration/details"
        
        // MARK: - Users
        case .phoneVerification:
            return "users/users/phone/verification/"
        case .phoneConfirmation:
            return "users/users/phone/confirmation/"
        case .isUserExists:
            return "users/users/phone/exist/"
        case .getSecureCode:
            return "users/users/phone/code/"
        case .updateUserInfo:
            return "users/users/me/"
        case .getUserInfo:
            return "users/users/me/"
        case .updateAvatar:
            return "users/users/me/"
            
        // MARK: - Plans
        case .getPlans:
            return "meal-plans/plans/"
        case .buyPlan:
            return "meal-plans/plans/"
        case .getSession(let id):
            return "/meal-plans/sessions/\(id)/"
        case .getProducts(let id):
            return "/meal-plans/sessions/\(id)/recommendations/"
        case .activateSession(let id):
            return "/meal-plans/sessions/\(id)/activate/"
            
        // MARK: - News
        case .getNewsCategories:
            return "/news/news/categories/"
        case .getNews:
            return "/news/news/"
        }
    }
    
    var httpMethod: String {
        switch self {
        
        // MARK: - Configuration
        case .getPreviewDetails:
            return "GET"
        
        // MARK: - Users
        case .phoneVerification, .phoneConfirmation, .getSecureCode, .isUserExists:
            return "POST"
        case .updateUserInfo:
            return "PUT"
        case .getUserInfo:
            return "GET"
        case .updateAvatar:
            return "PUT"
            
        // MARK: - Plans
        case .getPlans, .buyPlan, .getSession, .getProducts, .activateSession:
            return "GET"
            
        // MARK: - News
        case .getNewsCategories, .getNews:
            return "GET"
            
//        // MARK: - Stages
//        case .getStage, .getProducts, .stageForward:
//            return "GET"
        }
    }
    
    var data: Data? {
        switch self {
        
        // MARK: - Configuration
        case .getPreviewDetails:
            return nil
        
        // MARK: - Users
        case .phoneVerification(let phoneNumber):
            return try? JSONSerialization.data(withJSONObject: ["phone_number": phoneNumber], options: [])
        case .phoneConfirmation(let phoneNumber, let sessionToken, let securityCode):
            return try? JSONSerialization.data(withJSONObject: ["phone_number": phoneNumber, "session_token": sessionToken, "security_code": securityCode], options: [])
        case .isUserExists(let phoneNumber):
            return try? JSONSerialization.data(withJSONObject: ["phone_number": phoneNumber], options: [])
        case .getSecureCode(let phoneNumber):
            return try? JSONSerialization.data(withJSONObject: ["phone_number": phoneNumber], options: [])
        case .updateUserInfo(let userInfo):
            return try? jsonEncoder.encode(userInfo)
        case .getUserInfo:
            return nil
        case .updateAvatar:
            return nil
            
        // MARK: - Plans
        case .getPlans, .buyPlan, .getSession, .getProducts, .activateSession:
            return nil
            
        // MARK: - News
        case .getNewsCategories, .getNews:
            return nil
            
//        // MARK: - Stages
//        case .getStage, .getProducts, .stageForward:
//            return nil
        }
    }
}
