//
//  TopRoundedView.swift
//  ProEdu
//
//  Created by Raz  on 18.12.20.
//

import Foundation
import UIKit

@IBDesignable
class TopRoundedView: UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
            self.layoutIfNeeded()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        roundCorners(corners: [.topLeft, .topRight], radius: cornerRadius)
    }
}

extension UIView {
   func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
