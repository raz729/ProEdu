//
//  CustomView.swift
//  ProEdu
//
//  Created by Raz  on 10/30/20.
//

import Foundation
import UIKit

@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0 {
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .clear {
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var disabledBorderColor: UIColor = .clear {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var disabledColor: UIColor = .clear {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable
    var normalColor: UIColor = .clear {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if isEnabled {
            backgroundColor = normalColor
            layer.borderColor = borderColor.cgColor
        } else {
            backgroundColor = disabledColor
            layer.borderColor = disabledBorderColor.cgColor
        }
    }
}
