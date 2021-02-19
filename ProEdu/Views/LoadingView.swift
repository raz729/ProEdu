//
//  LoadingView.swift
//  ProEdu
//
//  Created by Raz  on 11/1/20.
//

import Foundation
import UIKit

class LoadingView: UIView {
    
    private let spinnerView = SpinnerView()
    
    static let shared = LoadingView()
    
    override private init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(spinnerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        spinnerView.frame.size = CGSize(width: 60, height: 60)
        spinnerView.center = center
    }
    
    func showLoading(in view: UIView, bottomPadding: CGFloat = 0, with backAlpha: CGFloat = 0.2) {
        frame = view.bounds
        frame.size.height -= bottomPadding
        view.addSubview(self)
        
        backgroundColor = UIColor.black.withAlphaComponent(backAlpha)
    }
    
    func hideLoading() {
        removeFromSuperview()
    }
}
