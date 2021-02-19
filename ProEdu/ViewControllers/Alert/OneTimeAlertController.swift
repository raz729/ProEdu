//
//  OneTimeAlertController.swift
//  ProEdu
//
//  Created by Raz  on 24.11.20.
//

import UIKit

class OneTimeAlertController: UIViewController {
    
    @IBOutlet weak var textLabel: UILabel!
    
    private var completion: (() -> Void)?
    private var phoneNumber: String
    
    init(phoneNumber: String, completion: (() -> Void)? = nil) {
        self.phoneNumber = phoneNumber
        self.completion = completion
        
        super.init(nibName: "OneTimeAlertController", bundle: nil)
        
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        textLabel.text = "Код подтверждения был отправлен на номер \(phoneNumber)"
    }

    @IBAction func confirmAction() {
        dismiss(animated: true, completion: completion)
    }
    
}
