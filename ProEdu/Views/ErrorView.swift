//
//  ErrorView.swift
//  ProEdu
//
//  Created by Raz  on 10/30/20.
//

import Foundation
import UIKit

@IBDesignable
class ErrorView: UIView {
    
    private var errorLabel: UILabel = UILabel()
    private var isShowError: Bool = false
    
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
    var errorColor: UIColor = .red {
        didSet {
            errorLabel.textColor = errorColor
        }
    }
    
    @IBInspectable
    var errorText: String = "" {
        didSet {
            errorLabel.text = errorText
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
        errorLabel.frame = CGRect(x: 0, y: bounds.height + 10, width: bounds.width, height: 22)
        errorLabel.isHidden = true
        errorLabel.font = Constants.Fonts.regular16
        
        addSubview(errorLabel)
    }
    
    override func layoutSubviews() {
        frame.origin.y -= isShowError ? 32 : 0
    }
    
    func showError() {
        if isShowError {
            return
        }
        
        isShowError = true
        self.layer.borderColor = errorColor.cgColor
        self.errorLabel.isHidden = false
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.y -= 32
        }
    }
    
    func hideError() {
        if !isShowError {
            return
        }
        isShowError = false
        self.layer.borderColor = borderColor.cgColor
        self.errorLabel.isHidden = true
        
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.y += 32
        }
    }
}
