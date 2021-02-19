//
//  AlertViewController.swift
//  ProEdu
//
//  Created by Raz  on 11/7/20.
//

import UIKit

class AlertViewController: UIViewController {
    
    private let errorImage: UIImage = UIImage(named: "ic_alert_error")!
    private let confirmedImage: UIImage = UIImage(named: "ic_alert_confirm")!
    private let buttonErrorTitle: String = Constants.Strings.repeat_
    private let buttonConfirmedTitle: String = Constants.Strings.close

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var closeButton: CustomButton!
    
    @IBOutlet weak var alertHeightConstraint: NSLayoutConstraint!
    
    private var title_: String
    private var message: String
    private var isError: Bool = false
    private var completion: (() -> Void)?
    
    private var image: UIImage {
        return isError ? errorImage : confirmedImage
    }
    
    private var buttonTitle: String {
        return (isError ? buttonErrorTitle : buttonConfirmedTitle).uppercased()
    }
    
    init(title: String, message: String, isError: Bool, completion: (() -> Void)? = nil) {
        self.title_ = title
        self.message = message
        self.isError = isError
        self.completion = completion
        
        super.init(nibName: "AlertViewController", bundle: nil)
        
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = title_
        messageLabel.text = message
        imageView.image = image
        closeButton.setTitle(buttonTitle, for: .normal)
    }
    
    @IBAction func closeAction() {
        self.dismiss(animated: true, completion: completion)
    }
    
}
