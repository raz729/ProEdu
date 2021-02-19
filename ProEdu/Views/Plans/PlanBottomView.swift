//
//  PlanBottomView.swift
//  ProEdu
//
//  Created by Raz  on 11/8/20.
//

import Foundation
import UIKit

class PlanBottomView: UIView {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainView: RoundedView!
    @IBOutlet weak var ruleView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tableViewHeightConstraint: NSLayoutConstraint!
    
    var cellHeights: [IndexPath: CGFloat] = [:]
    var heightCallback: ((CGFloat) -> Void)? = nil
    
    private let section1Data: [String] = ["яйца ;", "птица ( до 2-3-х раз в неделю ) ;", "мясо ( до 2х раз в неделю ) ;", "субпродукты ( до 5 раз в неделю ) ;", "рыба (особенно жирная) ;", "икра из рыбы ;", "морепродукты ;", "костный бульйон или холодец.",]
    
    private let section2Data: [String] = ["масло авокадо, кокоса, оливковое, сливочное, топленое (гхи), кокосовое молоко и сливки, конопляное, льяное, грецкого ореха ;", "сало ;", "“жирные” фрукты: авокадо, оливки, кокос и продукты из него ;", "семена и орехи, предварительно замоченные в подкисленной воде ;"]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle(for: PlanBottomView.self)
        bundle.loadNibNamed("PlanBottomView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        tableView.register(UINib(nibName: OptionCell.name, bundle: nil), forCellReuseIdentifier: OptionCell.identifier)
        
        tableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    tableViewHeightConstraint.constant = newSize.height
                    self.frame.size.height = ruleView.frame.maxY + 16 + tableView.frame.height
                    let contnentHeight = bounds.height
                    contentView.frame.size.height = contnentHeight
                    mainView.frame.size.height = contnentHeight
                    heightCallback?(contnentHeight)
                }
            }
        }
    }
}

// MARK: - TableViewDelegate
extension PlanBottomView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? section1Data.count : section2Data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OptionCell.identifier, for: indexPath) as! OptionCell
        
        if indexPath.section == 0 {
            cell.txtLabel.text = section1Data[indexPath.row]
        } else {
            cell.txtLabel.text = section2Data[indexPath.row]
        }
        
        cellHeights[indexPath] = cell.height
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sectionView = PlanSectionView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 30))
        sectionView.title = section == 0 ? "Варианты белковых продуктов:" : "Варианты белковых жиров:"
        
        return sectionView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath.section == 0 && indexPath.row == section1Data.count - 1) ||
            (indexPath.section == 1 && indexPath.row == section2Data.count - 1) {
            return (cellHeights[indexPath] ?? 0) + 20
        }
        
        return cellHeights[indexPath] ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
