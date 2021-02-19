//
//  OptionCell.swift
//  ProEdu
//
//  Created by Raz  on 11/8/20.
//

import UIKit

class OptionCell: UITableViewCell {
    
    static let name: String = "OptionCell"
    static let identifier: String = "kOptionCell"

    @IBOutlet weak var txtLabel: UILabel!
    
    var height: CGFloat {
        if let height = txtLabel.text?.height(withConstrainedWidth: txtLabel.frame.width + 10, font: txtLabel.font) {
            return height + 10
        }
        return 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
