//
//  SubscriptionCell.swift
//  ProEdu
//
//  Created by Raz  on 18.12.20.
//

import UIKit

class SubscriptionCell: UITableViewCell {
    
    static let name = "SubscriptionCell"
    static let identifier = "kSubscriptionCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var periodLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func set(price: Price) {
        titleLabel.text = price.title
        descLabel.text = price.priceDescription != nil && !price.priceDescription!.isEmpty ? price.priceDescription! : "Нужен текст"
        priceLabel.text = "\(price.amount ?? 0)"
        if let p = price.period, let period = Period(rawValue: p) {
            periodLabel.text = period.value
        }
    }
    
}
