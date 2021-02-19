//
//  PlanViewController.swift
//  ProEdu
//
//  Created by Raz  on 11/7/20.
//

import UIKit
import AVKit

class PlanViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var topView: PlanTopView!
    @IBOutlet weak var fullDescriptionLabel: UILabel!
    
    @IBOutlet weak var selectButton: CustomButton!
    @IBOutlet weak var selectButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var selectButtonBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topHeightConstraint: NSLayoutConstraint!
    
    var offsetY: CGFloat = 0
    
    var plan: Plan? = nil
    
    var isSelectbale: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fullDescriptionLabel.attributedText = (plan?.fullDescription ?? "").htmlAttributedString(size: 16)

        topView.heightCallback = { [weak self] height in
            if let me = self {
                me.topHeightConstraint.constant = height
                me.scrollView.contentOffset.y = me.offsetY
            }
        }
        topView.plan = plan
        topView.delegate = self
        
        updateView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.orientation = .portrait
        
        UIView.performWithoutAnimation {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        }
    }
    
    @IBAction func selectAction() {
        //
    }
    
    private func updateView() {
        if !isSelectbale {
            selectButton.isHidden = true
            selectButtonHeightConstraint.constant = 0
            selectButtonBottomConstraint.constant = 0
        }
    }
    
    func setupNavBar() {
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_back_white"), style: .plain, target: self, action: #selector(backAction))
        navigationItem.leftBarButtonItem = backButton
        
        navigationController?.interactivePopGestureRecognizer?.delegate = nil
    }
    
    @objc
    func backAction() {
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - ScrollViewDelegate
extension PlanViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        offsetY = scrollView.contentOffset.y
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        offsetY = scrollView.contentOffset.y
    }
}

// MARK: - PlanTopViewDelegate
extension PlanViewController: PlanTopViewDelegate {
    func addChild(controller: AVPlayerViewController) {
        self.addChild(controller)
    }
}

extension UIViewController {
    func removeChildViewControllers() {
        if self.children.count > 0 {
            let viewControllers:[UIViewController] = self.children
            for viewController in viewControllers {
                viewController.willMove(toParent: nil)
                viewController.view.removeFromSuperview()
                viewController.removeFromParent()
            }
        }
    }
}
