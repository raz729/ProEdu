//
//  NewsCell.swift
//  ProEdu
//
//  Created by Raz  on 25.11.20.
//

import UIKit
import SDWebImage
import AVKit
import AVFoundation

protocol NewsCellDelegate: class {
    func play(with url: URL)
}

class NewsCell: UITableViewCell {
    
    static let name = "NewsCell"
    static let identifier = "kNewsCell"

    @IBOutlet weak var playView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var divideView: UIView!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    private var news: News?
    
    weak var delegate: NewsCellDelegate? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectionStyle = .none
    }
    
    func set(news: News) {
        self.news = news
        nameLabel.text = news.title
        descLabel.text = news.subtitle
        
        if let imgPath = news.video?.preview, let imgURL = URL(string: Constants.URLs.baseURL + imgPath) {
            imgView.sd_setImage(with: imgURL, placeholderImage: UIImage(named: "placeholder-image"))
        }
    }
    
    @IBAction func playAction() {
        if let videoURLStr = news?.video?.file, let videoURL = URL(string: "\(Constants.URLs.baseURL)\(videoURLStr)") {
            delegate?.play(with: videoURL)
        }
    }
    
    private func updatePlayState(_ isPlaying: Bool) {
        playView.isHidden = isPlaying
        imgView.isHidden = isPlaying
        videoView.isHidden = !isPlaying
    }
    
}
