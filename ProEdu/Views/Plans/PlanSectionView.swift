//
//  PlanSectionView.swift
//  ProEdu
//
//  Created by Raz  on 11/8/20.
//

import Foundation
import UIKit

@IBDesignable
class PlanSectionView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBInspectable
    var title: String? {
        set {
            titleLabel.text = newValue
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
        get {
            titleLabel.text
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: PlanSectionView.self)
        bundle.loadNibNamed("PlanSectionView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        
        commonInit()
    }
}
