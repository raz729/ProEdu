//
//  SubscribeButton.swift
//  ProEdu
//
//  Created by Raz  on 11/8/20.
//

import Foundation
import UIKit

class SubscribeButton: UIControl {
    
    @IBOutlet var contentView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: SubscribeButton.self)
        bundle.loadNibNamed("SubscribeButton", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
    }
    
    @IBAction func action() {
        sendActions(for: .touchUpInside)
    }
    
}
