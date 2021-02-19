//
//  StageCell.swift
//  ProEdu
//
//  Created by Raz  on 16.12.20.
//

import UIKit

class StageCell: UITableViewCell {
    
    static let name = "StageCell"
    static let identifier = "kStageCell"
    
    private let enabledColor: UIColor = UIColor(named: "AccentColor")!
    private let disabledColor: UIColor = UIColor(red: 196/255, green: 196/255, blue: 196/255, alpha: 1)

    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var borderView: RoundedView!
    
    @IBOutlet weak var recomendLabel: UILabel!
    @IBOutlet weak var sliderView: UIView!
    @IBOutlet var weekLabels: [UILabel]!
    @IBOutlet weak var meedWeekLabel: UILabel!
    @IBOutlet weak var maxWeekLabel: UILabel!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    
    var isEnabled: Bool = false {
        didSet {
            titleLabel.textColor = isEnabled ? enabledColor : disabledColor
            borderView.borderColor = isEnabled ? enabledColor : disabledColor
        }
    }
    
    var isExpanded: Bool = false {
        didSet {
            updateView()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
        slider.setThumbImage(UIImage(named: "slider_thumb"), for: .normal)
//        slider.value = 0.2
    }
    
    func updateView() {
        heightConstraint.constant = isExpanded ? 173 : 57
        recomendLabel.isHidden = !isExpanded
        sliderView.isHidden = !isExpanded
        weekLabels.forEach { (lbl) in
            lbl.isHidden = !isExpanded
        }
    }

    func set(stage: PlanStage, currentStage: CurrentStage?) {
        titleLabel.text = stage.title
        
        if let thresold = currentStage?.progress.threshold {
            recomendLabel.text = "Рекомендуемая длительность \(thresold) недель"
        }
        
        if let max = currentStage?.progress.max {
            maxWeekLabel.text = "\(max) неделя"
            meedWeekLabel.text = "\(Int(max/2) + 1) неделя"
            slider.maximumValue = Float(max)
        }
        
        if let current = currentStage?.progress.current {
            slider.value = Float(current)
        }
    }
}
