//
//  PlanViewCell.swift
//  ProEdu
//
//  Created by Raz  on 11/1/20.
//

import UIKit

class PlanViewCell: UITableViewCell {
    
    static let name = "PlanViewCell"
    static let identifier = "kPlanViewCell"
    
    private let oddColor: UIColor = Constants.Colors.accentColor
    private let evenColor: UIColor = Constants.Colors.liteGreenColor

    @IBOutlet weak var baseView: CustomView!
    @IBOutlet weak var colorView: RoundedView!
    @IBOutlet weak var lockView: RoundedView!
    @IBOutlet weak var subscribeStackView: UIStackView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var price2Label: UILabel!
    
    @IBOutlet weak var subscribeLabel: UILabel!
    
    var isOdd: Bool = false {
        didSet {
            updateColor()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        if UIDevice.modelName == "iPhone SE" || UIDevice.modelName == "Simulator iPhone SE" {
            subscribeLabel.font = subscribeLabel.font.withSize(12.5)
            price2Label.font = price2Label.font.withSize(12.5)
        }
    }
    
    func set(planModel: PlanModel) {
        titleLabel.text = planModel.title?.uppercased()
        descLabel.attributedText = planModel.description?.htmlAttributedString(size: 14, color: Constants.Colors.grayColor)
        priceLabel.text = planModel.price
        price2Label.text = planModel.price
        
        lockView.isHidden = planModel.isPurchased
        priceLabel.isHidden = planModel.isPurchased
        subscribeStackView.isHidden = !planModel.isPurchased
    }
    
    func set(plan: Plan, isActive: Bool) {
        titleLabel.text = plan.title
        descLabel.attributedText = plan.shortDescription?.htmlAttributedString(size: 14, color: Constants.Colors.grayColor)
        if let amount = plan.prices?.first?.amount {
            var underAmount: String = ""
            if let p = plan.prices?.first?.period, let period = Period(rawValue: p), period != .allTime {
                underAmount = " / \(period.shortValue)"
            }
            
            let price = "\(amount) руб.\(underAmount)"
            priceLabel.text = price
            price2Label.text = price
        }
        
        lockView.isHidden = isActive
        priceLabel.isHidden = isActive
        subscribeStackView.isHidden = !isActive
        
    }
    
    private func updateColor() {
        colorView.backgroundColor = isOdd ? oddColor : evenColor
    }
    
}
