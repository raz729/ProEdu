//
//  PlanTopView.swift
//  ProEdu
//
//  Created by Raz  on 11/7/20.
//

import Foundation
import UIKit
import AVKit

protocol PlanTopViewDelegate: class {
    func addChild(controller: AVPlayerViewController)
}

class PlanTopView: UIView {
    
    private let tableViewTopPadding: CGFloat = 0
    private let tableViewBottomPadding: CGFloat = 5
    
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var mainView: RoundedView!
    @IBOutlet weak var stagesTableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var previewView: UIImageView!
    @IBOutlet weak var playView: UIView!
    
    @IBOutlet weak var stagesTableViewHeightConstraint: NSLayoutConstraint!
    
    private var cellHeights: [IndexPath: CGFloat] = [:]
    private var selectedIndexPath: IndexPath? = nil
    private var stages: [PlanStage] = []
    
    var player: AVPlayer?
    
    var heightCallback: ((CGFloat) -> Void)? = nil
    weak var delegate: PlanTopViewDelegate? = nil
    
    var plan: Plan? = nil {
        didSet {
            updateData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        commonInit()
    }
    
    deinit {
        stagesTableView.removeObserver(self, forKeyPath: "contentSize")
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    private func commonInit() {
        let bundle = Bundle(for: PlanTopView.self)
        bundle.loadNibNamed("PlanTopView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        stagesTableView.register(UINib(nibName: PlanStageCell.name, bundle: nil), forCellReuseIdentifier: PlanStageCell.identifier)
        
        stagesTableView.addObserver(self, forKeyPath: "contentSize", options: .new, context: nil)
        stagesTableView.reloadData()
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd),
                                                                 name: .AVPlayerItemDidPlayToEndTime,
                                                                 object: nil)
    }
    
    func updateData() {
        titleLabel.text = plan?.title?.uppercased()
//        descLabel.text = plan?.shortDescription
        descLabel.attributedText = plan?.shortDescription?.htmlAttributedString(size: 16, color: UIColor(named: "GrayColor")!)
        
        stages = plan?.stages ?? []
        stages = stages.sorted(by: { $0.order! < $1.order! })
        stagesTableView.reloadData()
        
        if let imgPath = plan?.video?.preview, let imgURL = URL(string: Constants.URLs.baseURL + imgPath) {
            previewView.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "placeholder-image"))
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentSize" {
            if object is UITableView {
                if let newValue = change?[.newKey] {
                    let newSize = newValue as! CGSize
                    stagesTableViewHeightConstraint.constant = newSize.height
                    self.frame.size.height = descLabel.frame.maxY + tableViewTopPadding + stagesTableView.frame.height
                    let contnentHeight = bounds.height + tableViewBottomPadding
                    contentView.frame.size.height = contnentHeight
                    mainView.frame.size.height = contnentHeight
                    heightCallback?(contnentHeight)
                }
            }
        }
    }
    
    @IBAction func playAction() {
        if player == nil {
            if let file = plan?.video?.file, let url = URL(string: "\(Constants.URLs.baseURL)\(file)") {
                player = AVPlayer(url: url)
                player?.externalPlaybackVideoGravity = .resizeAspectFill
                let controller = AVPlayerViewController()
                controller.videoGravity = .resizeAspectFill
                controller.player = player
                controller.view.frame = self.videoView.frame
                self.videoView.addSubview(controller.view)
                player?.play()
                delegate?.addChild(controller: controller)
            }
        }
        
        if player != nil {
            updatePlayState(true)
            player?.play()
        }
    }
    
    func updatePlayState(_ isPlaying: Bool) {
        playView.isHidden = isPlaying
        previewView.isHidden = isPlaying
    }
}

extension PlanTopView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PlanStageCell.identifier, for: indexPath) as! PlanStageCell
        if let sIndexPath = selectedIndexPath, sIndexPath == indexPath {
            cell.isExpanded = true
        } else {
            cell.isExpanded = false
        }
        
        cellHeights[indexPath] = cell.height
        cell.set(stage: stages[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let sIndexPath = selectedIndexPath, sIndexPath == indexPath {
            selectedIndexPath = nil
        } else {
            selectedIndexPath = indexPath
        }
        
        stagesTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath] ?? 0
    }
}

extension PlanTopView
{
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        player?.seek(to: CMTime.zero)
        updatePlayState(false)
    }
}
