//
//  AboutYangViewController.swift
//  ProEdu
//
//  Created by Raz  on 19.11.20.
//

import UIKit

class AboutYangViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func instagramAction() {
        let appURL = Constants.SocialNetwork.instagramAppURL
        let application = UIApplication.shared
        
        if application.canOpenURL(appURL) {
            application.open(appURL)
        } else {
            let webURL = Constants.SocialNetwork.instagramWebURL
            application.open(webURL)
        }
    }
    
    @IBAction func youtubeAction() {
        let youtubeAppURL = Constants.SocialNetwork.youtubeAppURL
        let application = UIApplication.shared
        
        if application.canOpenURL(youtubeAppURL){
            application.open(youtubeAppURL)
        } else{
            let youtubeWebURL = Constants.SocialNetwork.youtubeWebURL
            application.open(youtubeWebURL)
        }
    }
    
}
