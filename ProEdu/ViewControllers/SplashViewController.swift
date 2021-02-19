//
//  SplashViewController.swift
//  ProEdu
//
//  Created by Raz  on 11/5/20.
//

import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
            NetworkManager.shared.getPreview { [weak self] (previewResult) in
                switch previewResult {
                case .success(let previewDetails):
                    if let previewURLstr = previewDetails.dashboardVideo?.preview,
                       let previewURL = URL(string: "\(Constants.URLs.baseURL)\(previewURLstr)") {
                        var previewImg: UIImage? = nil
                        if let imageData = try? Data(contentsOf: previewURL) {
                            previewImg = UIImage(data: imageData)
                        }
                        
                        NetworkManager.shared.getUserInfo { (userInfoResult) in
                            var valid = false
                            switch userInfoResult {
                            case .success(_):
                                valid = true
                            case .failure(_):
                                valid = false
                            }
                            
                            DispatchQueue.main.async {
                                let mainVC = Constants.Storyboards.auth.instantiateViewController(withIdentifier: Constants.VCIdentifiers.mainVC) as! MainViewController
                                mainVC.set(previewImg: previewImg, videoURL: previewDetails.dashboardVideo?.file)
                                
                                if valid {
                                    let plansVC = Constants.Storyboards.main.instantiateViewController(withIdentifier: Constants.VCIdentifiers.tabVC)
                                    self?.navigationController?.viewControllers.append(mainVC)
                                    self?.navigationController?.pushViewController(plansVC, animated: false)
                                } else {
                                    self?.navigationController?.pushViewController(mainVC, animated: false)
                                }
                            }
                            
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        
        setNeedsStatusBarAppearanceUpdate()
    }
    
    //MARK: - StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
