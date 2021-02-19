//
//  RegNameViewController.swift
//  ProEdu
//
//  Created by Raz  on 11/1/20.
//

import UIKit

class RegNameViewController: UIViewController {

    @IBOutlet weak var nameTF: CustomTextField!
    @IBOutlet weak var regButton: CustomButton!
    
    var token: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextField()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        nameTF.becomeFirstResponder()
    }
    
    func openPlansVC() {
        let tabVC = Constants.Storyboards.main.instantiateViewController(withIdentifier: Constants.VCIdentifiers.tabVC)
        navigationController?.pushViewController(tabVC, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func regAction() {
        view.endEditing(true)
        LoadingView.shared.showLoading(in: self.view)
        
        var userInfo = UserInfo()
        userInfo.firstName = nameTF.text
        
        AppManager.token = self.token
        NetworkManager.shared.updateUserInfo(userInfo) { [weak self] (updateResult) in
            DispatchQueue.main.async {
                switch updateResult {
                case .success(_):
                    self?.openPlansVC()
                case .failure(let error):
                    let error = NetworkManager.handle(error: error)
                    self?.showErrorAlert(with: Constants.Strings.error, message: error, completion: nil)
                    AppManager.token = nil
                }
                
                LoadingView.shared.hideLoading()
            }
        }
    }
    
    @IBAction func backAction() {
        navigationController?.popToViewController((navigationController?.viewControllers[1])!, animated: true)
    }
    
    //MARK: - StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
}

extension RegNameViewController {
    func setupTextField() {
        nameTF.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc func editingChanged() {
        let mobile = nameTF.text
        regButton.isEnabled = mobile!.count > 1
    }
}
