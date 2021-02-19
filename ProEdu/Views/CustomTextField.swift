//
//  CustomSwitch.swift
//  ProEdu
//
//  Created by Raz  on 10/30/20.
//

import Foundation
import UIKit

class CustomTextField: UITextField {
    
    @IBInspectable
    var txtColor: UIColor = .clear {
        didSet {
            textColor = txtColor
        }
    }
    
    @IBInspectable
    var placeholderColor: UIColor = .gray {
        didSet {
            self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "",
                                         attributes: [NSAttributedString.Key.foregroundColor: placeholderColor])
        }
    }
    
    @IBInspectable
    var errorColor: UIColor = .red
    
    func showError() {
        textColor = errorColor
    }
    
    func hideError() {
        textColor = txtColor
    }
}
