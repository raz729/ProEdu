//
//  MoreViewController.swift
//  ProEdu
//
//  Created by Raz  on 30.11.20.
//

import UIKit

class MoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func exitAction() {
        AppManager.token = nil
        openRootVCIfNeeded()
    }
    

}
