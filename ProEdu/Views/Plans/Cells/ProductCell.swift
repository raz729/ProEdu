//
//  ProductCell.swift
//  ProEdu
//
//  Created by Raz  on 22.11.20.
//

import UIKit

class ProductCell: UITableViewCell {
    
    static let name: String = "ProductCell"
    static let identifier: String = "kProductCell"

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var breakfastImgView: UIImageView!
    @IBOutlet weak var lunchImgView: UIImageView!
    @IBOutlet weak var snackImgView: UIImageView!
    @IBOutlet weak var dinnerImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }

    func set(product: Product) {
        nameLabel.text = product.detail?.title
        breakfastImgView.image = UIImage(named: product.breakfast ?? "")
        lunchImgView.image = UIImage(named: product.lunch ?? "")
        snackImgView.image = UIImage(named: product.snack ?? "")
        dinnerImgView.image = UIImage(named: product.dinner ?? "")
    }
    
}
