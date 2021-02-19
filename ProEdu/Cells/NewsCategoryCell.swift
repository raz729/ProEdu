//
//  NewsCategoryCell.swift
//  ProEdu
//
//  Created by Raz  on 24.11.20.
//

import UIKit

class NewsCategoryCell: UICollectionViewCell {
    
    static let name = "NewsCategoryCell"
    static let identifier = "kNewsCategoryCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        updateSelection()
    }

    override var isSelected: Bool {
        didSet {
            updateSelection()
        }
    }
    
    private func updateSelection() {
        nameLabel.textColor = isSelected ? Constants.Colors.titleColor : Constants.Colors.grayColor
        selectedView.isHidden = !isSelected
    }
}
