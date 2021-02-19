//
//  AppManager.swift
//  ProEdu
//
//  Created by Raz  on 11/5/20.
//

import Foundation

class AppManager {
    
    private static let tokenKey: String = "kToken"
    
    static var token: String? {
        set {
            UserDefaults.standard.setValue(newValue, forKey: tokenKey)
        }
        get {
            return UserDefaults.standard.value(forKey: tokenKey) as? String
        }
    }
    
}
