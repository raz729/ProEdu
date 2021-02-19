//
//  PlanStageCell.swift
//  ProEdu
//
//  Created by Raz  on 11/7/20.
//

import UIKit

class PlanStageCell: UITableViewCell {
    
    private let padding: CGFloat = 0
    
    static let name: String = "PlanStageCell"
    static let identifier: String = "kPlanStageCell"

    @IBOutlet weak var sectionView: PlanSectionView!
    @IBOutlet weak var stageLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ruleLabel: UILabel!
    @IBOutlet weak var ruleView: UIView!
    
    var isExpanded: Bool = false
    var canExpand: Bool {
        return stage?.description != nil && !stage!.description!.isEmpty
    }
    
    var height: CGFloat {
        if isExpanded && canExpand {
            return ruleView.frame.maxY + padding
        } else {
            return descLabel.frame.minY + descLabel.text!.height(withConstrainedWidth: descLabel.frame.width, font: descLabel.font) + padding
        }
    }
    
    var stage: PlanStage?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if canExpand {
            isExpanded = selected
            ruleView.isHidden = isExpanded
        }
    }
    
    func set(stage: PlanStage?) {
        self.stage = stage
        self.stage?.description = stage?.description != nil && !stage!.description!.isEmpty ? stage?.description : "Нужен текст"
        
        if let order = stage?.order {
            stageLabel.text = "\(order + 1) этап"
        }
        descLabel.text = stage?.title
        ruleLabel.text = self.stage?.description
    }
    
}
