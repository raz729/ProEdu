//
//  RegCodeViewController.swift
//  ProEdu
//
//  Created by Raz  on 10/31/20.
//

import UIKit

class RegCodeViewController: UIViewController {
    
    private let oneTimeCodeLength: Int = 4
    
    @IBOutlet var codeTFs: [CustomTextField]!
    @IBOutlet weak var errorMsgLabel: UILabel!
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var sendAgainButton: CustomButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confirmNumberTextLabel: UILabel!
    
    let model = VerificationModel()
    
    private let dispatchGroup = DispatchGroup()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateLabels()
        startCodeTimer()
        phoneVerification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.codeDigits.removeAll()
        codeTFs.forEach { (tf) in
            tf.text = ""
            tf.delegate = self
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.viewWithTag(1)?.becomeFirstResponder()
    }
    
    private func startCodeTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { (timer) in
            self.model.duration -= 1
            self.updateTimer()
            
            if self.model.duration == 0 {
                timer.invalidate()
                self.timerButton.isEnabled = true
                self.sendAgainButton.isEnabled = true
            }
        }
    }
    
    private func updateTimer() {
        self.timerButton.setTitle("Через \(Int(self.model.duration)) сек", for: .disabled)
    }
    
    private func updateLabels() {
        titleLabel.text = model.isUserExist ? Constants.Strings.signIn : Constants.Strings.reg
        confirmNumberTextLabel.text = "Код подтверждения был отправлен на\nномер \(model.phoneNumber)"
    }
    
    func set(phoneNumber: String, isUserExist: Bool) {
        model.phoneNumber = phoneNumber
        model.isUserExist = isUserExist
    }
    
    func checkConfirmation() {
        LoadingView.shared.showLoading(in: self.view)
        phoneConfirmation()
        
//        if !model.isUserExist {
//            getUserInfo()
//        }
        
        dispatchGroup.notify(queue: .main) {
            LoadingView.shared.hideLoading()
            
            if self.model.confirmed {
                if self.model.isUserExist && !self.model.name.isEmpty {
                    AppManager.token = self.model.token
                    self.openPlansVC()
                } else {
                    self.openRegNameVC()
                }
            } else {
                self.showError()
            }
        }
    }
    
    private func showError() {
        self.codeTFs.forEach { (tf) in
            tf.showError()
        }
        self.errorMsgLabel.isHidden = false
    }
    
    private func hideError() {
        if !errorMsgLabel.isHidden {
            codeTFs.forEach { (tf) in
                tf.hideError()
            }
            errorMsgLabel.isHidden = true
        }
    }
    
    private func openRegNameVC() {
        codeTFs.forEach { (tf) in
            tf.delegate = nil
        }
        
        let regNameVC = storyboard?.instantiateViewController(withIdentifier: Constants.VCIdentifiers.regNameVC) as! RegNameViewController
        regNameVC.token = model.token
        navigationController?.pushViewController(regNameVC, animated: true)
    }
    
    private func openPlansVC() {
        let plansVC = Constants.Storyboards.main.instantiateViewController(withIdentifier: Constants.VCIdentifiers.tabVC)
        navigationController?.pushViewController(plansVC, animated: true)
    }
    
    // MARK: - Actions
    @IBAction func sendAgainAction() {
        model.resetDuration()
        timerButton.isEnabled = false
        sendAgainButton.isEnabled = false
        updateTimer()
        
        startCodeTimer()
        phoneVerification()
    }
    
    @IBAction func backAction() {
        navigationController?.popViewController(animated: true)
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

// MARK: - TextField
extension RegCodeViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" {
            if textField.text == "" {
                textField.text = string

                model.codeDigits.append(Int(string)!)
            } else {
                let nextResponder: UIResponder? = view.viewWithTag(textField.tag + 1)
                if let tF = nextResponder as? UITextField {
                    tF.text = string
                    model.codeDigits.append(Int(string)!)
                    nextResponder?.becomeFirstResponder()
                }
            }

            return false
        } else {
            textField.text = string

            if textField.tag - 1 < model.codeDigits.count {
                model.codeDigits.remove(at: textField.tag - 1)
            }

            let nextResponder: UIResponder? = view.viewWithTag(textField.tag - 1)
            if (nextResponder != nil) {
                nextResponder?.becomeFirstResponder()
            }
            return false
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if model.codeDigits.count == oneTimeCodeLength && !model.confirmed {
            checkConfirmation()
        } else {
            hideError()
        }
    }
}


// MARK: - Network
extension RegCodeViewController {
    private func phoneVerification() {
        NetworkManager.shared.phoneVerification(model.phoneNumber) { [weak self] (verificationResult) in
            switch verificationResult {
            case .success(let result):
                self?.model.sessionToken = result.sessionToken
                self?.getSecureCode()
            case .failure(let error):
                print(error.value ?? "")
            }
        }
    }
    
    private func phoneConfirmation() {
        dispatchGroup.enter()
        NetworkManager.shared.phoneConfirmation(model.phoneNumber, model.sessionToken ?? "", securityCode: model.securityCode) { (confirmationResult) in
            DispatchQueue.main.async {
                switch confirmationResult {
                case .success(let result):
                    if let token = result.access {
//                        AppManager.token = token
                        self.model.token = token
                        self.model.confirmed = true
                        self.getUserInfo()
                    } else {
                        self.showError()
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
                
                self.dispatchGroup.leave()
            }
        }
    }
    
    private func getSecureCode() {
        NetworkManager.shared.getSecureCode(model.phoneNumber) { [weak self] (codeResult) in
            switch codeResult {
            case .success(let result):
                let code = result["code"]
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self?.set(code: code!)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func getUserInfo() {
        dispatchGroup.enter()
        NetworkManager.shared.getUserInfo(token: self.model.token) { (userResult) in
            switch userResult {
            case .success(let userInfo):
                self.model.name = userInfo.firstName ?? ""
            case .failure(let error):
                print(error.localizedDescription)
            }
            
            self.dispatchGroup.leave()
        }
    }
}

// MARK: - Test
extension RegCodeViewController {
    func set(code: String) {
        for i in 0 ..< codeTFs.count {
            let label = codeTFs[i]
            let digit = String(code[code.index(code.startIndex, offsetBy: i)])
            label.text = digit
            model.codeDigits.append(Int(digit)!)
        }
        codeTFs.last!.becomeFirstResponder()
//        checkConfirmation()
    }
}

