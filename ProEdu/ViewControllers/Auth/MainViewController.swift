//
//  ViewController.swift
//  ProEdu
//
//  Created by Raz  on 10/30/20.
//

import UIKit
import AVKit
import AVFoundation
import PhoneNumberKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var errorView: ErrorView!
    @IBOutlet weak var phoneNumberTF: CustomTextField!
    @IBOutlet weak var loginButton: CustomButton!
    
    @IBOutlet weak var previewVideoView: UIView!
    @IBOutlet weak var previewImgView: UIImageView!
    @IBOutlet weak var playButton: UIButton!
    
    var previewImg: UIImage?
    var videoURL: String?
    
    private var player: AVPlayer?
    private var keyboardHeight: CGFloat = 0
    
    private var hideKeyboardCallback: (() -> Void)? = nil
    private let phoneNumberKit = PhoneNumberKit()
    
    private var foundValidNumber: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextField()
        contentView.hideKeyboardWhenTappedAround()
        
        previewImgView.image = previewImg
        
        setNeedsStatusBarAppearanceUpdate()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        contentView.frame.origin.y = 0
        phoneNumberTF.text = ""
        loginButton.isEnabled = false
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidReachEnd),
                                                                 name: .AVPlayerItemDidPlayToEndTime,
                                                                 object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        if keyboardHeight != 0 {
            contentView.frame.origin.y -= keyboardHeight
        }
    }
    
    func updatePlayState(_ isPlaying: Bool) {
        playButton.isHidden = isPlaying
        previewImgView.isHidden = isPlaying
        previewVideoView.isHidden = !isPlaying
    }
    
    func set(previewImg: UIImage?, videoURL: String?) {
        self.previewImg = previewImg
        self.videoURL = videoURL
    }
    
    // MARK: - Actions
    @IBAction func loginAction() {
        isUserExists()
    }
    
    @IBAction func playAction() {
        if player == nil {
            if let videoURLStr = videoURL, let videoURL = URL(string: "\(Constants.URLs.baseURL)\(videoURLStr)") {
                player = AVPlayer(url: videoURL)
                player?.externalPlaybackVideoGravity = .resizeAspectFill
                let controller = AVPlayerViewController()
                controller.videoGravity = .resizeAspectFill
                controller.player = player
                controller.view.frame = self.previewVideoView.frame
                self.previewVideoView.addSubview(controller.view)
                self.addChild(controller)
            }
        }
        
        if player != nil {
            updatePlayState(true)
            player?.play()
        }
        
    }
    
    //MARK: - StatusBar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        if #available(iOS 13.0, *) {
            return .darkContent
        } else {
            return .default
        }
    }
    
}

extension MainViewController {
    
    func setupTextField() {
        phoneNumberTF.addTarget(self, action: #selector(editingChanged), for: .editingChanged)
    }
    
    @objc func editingChanged() {
        var mobile = phoneNumberTF.text
        if !mobile!.hasPrefix("+") && !mobile!.isEmpty {
            mobile = "+\(mobile!)"
            phoneNumberTF.text = mobile
        }
        phoneNumberTF.text = PartialFormatter().formatPartial(mobile!)
        let phoneNumber = try? phoneNumberKit.parse(mobile!)
        loginButton.isEnabled = phoneNumber != nil // mobile!.isPhoneNumber
        
        if mobile!.count > 20 {
            errorView.showError()
        } else {
            errorView.hideError()
        }
    }
}

// MARK: - AV
extension MainViewController
{
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        player?.seek(to: CMTime.zero)
        updatePlayState(false)
    }
}

extension MainViewController {
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = (keyboardSize.height - 30 - self.view.safeAreaInsets.bottom)
            if contentView.frame.origin.y == 0 {
                UIView.animate(withDuration: 0.5) {
                    self.contentView.frame.origin.y -= (keyboardSize.height - 30 - self.view.safeAreaInsets.bottom)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = 0
            if contentView.frame.origin.y != 0 {
                UIView.animate(withDuration: 0.5) {
                    self.contentView.frame.origin.y = 0
                }
            }
        }
    }
}

// MARK: - Network
extension MainViewController {
    private func isUserExists() {
        LoadingView.shared.showLoading(in: self.view)
        
        NetworkManager.shared.isUserExists(phoneNumberTF.text!) { [weak self] (existResult) in
            DispatchQueue.main.async {
                switch existResult {
                case .success(let result):
                    if let self = self {
                        let regCodeVC = self.storyboard?.instantiateViewController(withIdentifier: Constants.VCIdentifiers.regCodeVC) as! RegCodeViewController
                        regCodeVC.set(phoneNumber: self.phoneNumberTF.text!, isUserExist: result.isExist ?? false)
                        
                        self.navigationController?.pushViewController(regCodeVC, animated: true)
                    }
                case .failure(let error):
                    let error = NetworkManager.handle(error: error)
                    self?.showErrorAlert(with: Constants.Strings.error, message: error, completion: nil)
                }
                
                LoadingView.shared.hideLoading()
            }
        }
    }
}
