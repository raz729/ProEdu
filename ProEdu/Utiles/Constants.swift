//
//  Constants.swift
//  ProEdu
//
//  Created by Raz  on 11/7/20.
//

import Foundation
import UIKit

class Constants {
    
    class Strings {
        static let success: String = "Успех"
        static let error: String = "Ошибка!"
        static let repeat_: String = "Повторить"
        static let close: String = "Закрыть"
        
        static let serverError: String = "Ошибка сервера"
        
        static let signIn: String = "Вход"
        static let reg: String = "Регистрация"
        
        static let dataSuccessfulyUpdated: String = "Данные успешно обновлены"
        
        static let takePhoto: String = "Сделать фотографию"
        static let choosePhoto: String = "Выбрать из фотографий"
        
        static let cancel: String = "Отмена"
        
        static let cameraAccess: String = "Доступ к камере"
        static let cameraPermissionMessage: String = "Доступ к камере было ранее отказано. Пожалуйста, разрешите доступ для этого приложения в Настройки -> Конфиденциальность."
        static let settings: String = "Настройки"
        
        static let searchProducts: String = "Найти продукты"
        
        static let all: String = "Все"
    }
    
    class Fonts {
        static var semibold12: UIFont { UIFont(name: "ProximaNova-Semibold", size: 12) ?? UIFont.systemFont(ofSize: 12, weight: .semibold) }
        static var regular16: UIFont { UIFont(name: "ProximaNova-Regular", size: 16) ?? UIFont.systemFont(ofSize: 16, weight: .regular) }
        static var bold14: UIFont { UIFont(name: "ProximaNova-Bold", size: 14) ?? UIFont.systemFont(ofSize: 14, weight: .bold) }
    }
    
    class URLs {
        static let apiBaseURL = "https://proedu.nicecode.biz/api/v1"
        static let baseURL = "https://proedu.nicecode.biz"
    }
    
    class Storyboards {
        static let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        static let auth: UIStoryboard = UIStoryboard(name: "Auth", bundle: nil)
        static let plans: UIStoryboard = UIStoryboard(name: "Plans", bundle: nil)
        static let recipes: UIStoryboard = UIStoryboard(name: "Recipes", bundle: nil)
    }
    
    class VCIdentifiers {
        static let mainVC: String = "mainVC"
        static let tabVC: String = "tabVC"
        static let planVC: String = "planVC"
        static let mealPlanVC: String = "mealPlanVC"
        static let regCodeVC: String = "regCodeVC"
        static let regNameVC: String = "regNameVC"
    }
    
    class Colors {
        static let accentColor: UIColor = UIColor(named: "AccentColor")!
        static let titleColor: UIColor = UIColor(named: "TitleColor")!
        static let grayColor: UIColor = UIColor(named: "GrayColor")!
        static let liteGreenColor: UIColor = UIColor(named: "LiteGreen")!
    }
    
    class SocialNetwork {
        private static let instagramUserName: String = ""
        
        static let instagramAppURL: URL = URL(string: "instagram://user?username=\(instagramUserName)")!
        static let instagramWebURL: URL = URL(string: "https://instagram.com/\(instagramUserName)")!
        
        private static let youtubeID: String = "UCbSMSYlB2jMaNNDw-iiUg1g"
        
        static let youtubeAppURL: URL = URL(string: "youtube://channel/\(youtubeID)")!
        static let youtubeWebURL: URL = URL(string:"https://www.youtube.com/channel/\(youtubeID)")!
    }
}
