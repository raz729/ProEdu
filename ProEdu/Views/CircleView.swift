//
//  CircleView.swift
//  ProEdu
//
//  Created by Raz  on 18.11.20.
//

import Foundation
import UIKit

@IBDesignable
class CircleView: UIView {
    
    override func layoutSubviews() {
        self.layer.cornerRadius = bounds.width/2
    }
}
