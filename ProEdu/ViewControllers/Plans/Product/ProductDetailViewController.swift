//
//  ProductDetailViewController.swift
//  ProEdu
//
//  Created by Raz  on 22.11.20.
//

import UIKit

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    
    private var name: String?
    private var desc: String?
    private var completion: (() -> Void)?
    
    init(name: String?, description: String?, completion: (() -> Void)? = nil) {
        self.name = name
        self.desc = description
        self.completion = completion
        
        super.init(nibName: "ProductDetailViewController", bundle: nil)
        
        self.modalPresentationStyle = .overCurrentContext
        self.modalTransitionStyle = .crossDissolve
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.text = name
        descLabel.text = desc
        
        setNeedsStatusBarAppearanceUpdate()
    }

    @IBAction func closeAction() {
        self.dismiss(animated: true, completion: completion)
    }
    
    
    //MARK: - StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .lightContent
        } else {
            return .default
        }
    }
}
