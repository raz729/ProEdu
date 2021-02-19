//
//  PersonalDataViewController.swift
//  ProEdu
//
//  Created by Raz  on 18.11.20.
//

import UIKit
import PhoneNumberKit
import Photos

class PersonalDataViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollContentView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var saveButton: CustomButton!
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    private var keyboardHeight: CGFloat = 0
    
    private var userInfo: UserInfo?
    private let phoneNumberKit = PhoneNumberKit()
    
    private var imageData: Data?
    
    private let dispatchGroup = DispatchGroup()
    private var errorMsg: String? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTextFields()
        getUserInfo()
        
        contentView.hideKeyboardWhenTappedAround()
        scrollContentView.hideKeyboardWhenTappedAround()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        LoadingView.shared.frame = scrollView.bounds
    }
    
    func updateInfo(avatar: UIImage? = nil) {
        let phoneNumber = userInfo?.phone
        userInfo?.phone = PartialFormatter().formatPartial(phoneNumber ?? "")
        nameTF.text = (userInfo?.firstName ?? "") + " " + (userInfo?.lastName ?? "")
        phoneNumberTF.text = userInfo?.phone
        emailTF.text = userInfo?.email
        avatarImageView.image = avatar
    }
    
    func isChanged() -> Bool {
        let phoneNumber = try? phoneNumberKit.parse(phoneNumberTF.text ?? "")
        let isValidPhone: Bool = phoneNumber != nil
        let isValidEmail: Bool = emailTF.text != "" ? emailTF.text!.isValidEmail() : true
        let imgChanged: Bool = imageData != nil
        
        return ((nameTF.text != userInfo?.firstName || phoneNumberTF.text != userInfo?.phone
                    || emailTF.text != userInfo?.email) && isValidPhone && isValidEmail || imgChanged)
    }
    
    @IBAction func saveAction() {
        errorMsg = nil
        
        LoadingView.shared.showLoading(in: self.scrollView)
        
        updateUserInfo()
        if imageData != nil {
            updateAvatar()
        }
        
        dispatchGroup.notify(queue: .main) {
            if let errorMsg = self.errorMsg {
                self.showErrorAlert(with: Constants.Strings.error, message: errorMsg)
            } else {
                self.saveButton.isEnabled = false
                self.showAlert(with: Constants.Strings.success, message: Constants.Strings.dataSuccessfulyUpdated)
            }
            
            LoadingView.shared.hideLoading()
        }
        
    }
    
    @IBAction func changeAvatarAction() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.view.tintColor = traitCollection.userInterfaceStyle == .dark ? .white : Constants.Colors.accentColor
        alertController.addAction(UIAlertAction(title: Constants.Strings.takePhoto, style: .default, handler: { (_) in
            self.cameraAction()
        }))
        
        alertController.addAction(UIAlertAction(title: Constants.Strings.choosePhoto, style: .default, handler: { (nil) in
            self.galleryAction()
        }))
        
        alertController.addAction(UIAlertAction(title: Constants.Strings.cancel, style: .cancel, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension PersonalDataViewController {
    func setupTextFields() {
        nameTF.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        phoneNumberTF.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
        emailTF.addTarget(self, action: #selector(editingChanged(_:)), for: .editingChanged)
    }
    
    @objc func editingChanged(_ sender: UITextField) {
        if sender == phoneNumberTF {
            var mobile = phoneNumberTF.text
            if !mobile!.hasPrefix("+") && !mobile!.isEmpty {
                mobile = "+\(mobile!)"
                phoneNumberTF.text = mobile
            }
            phoneNumberTF.text = PartialFormatter().formatPartial(mobile!)
        }
        
        saveButton.isEnabled = isChanged()
    }
}

extension PersonalDataViewController {
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardHeight == 0 {
                keyboardHeight = keyboardSize.height
                scrollView.contentOffset.y = scrollView.contentSize.height - scrollView.frame.height
                UIView.animate(withDuration: 0.5) {
                    self.contentView.frame.origin.y = -(keyboardSize.height/2 + 50)
                }
            }
        }
    }

    @objc func keyboardWillHide(notification: Notification) {
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if keyboardHeight != 0 {
                keyboardHeight = 0
                scrollView.contentOffset.y = 0
                UIView.animate(withDuration: 0.5) {
                    self.contentView.frame.origin.y = 0
                }
            }
        }
    }
}

// MARK: - Network
extension PersonalDataViewController {
    
    func getUserInfo() {
        LoadingView.shared.showLoading(in: view)
        NetworkManager.shared.getUserInfo { [weak self] (userResult) in
            switch userResult {
            case .success(let userInfo):
                self?.userInfo = userInfo
                
                NetworkManager.shared.getAvatar(with: userInfo.avatar ?? "") { (image) in
                    self?.updateInfo(avatar: image)
                    LoadingView.shared.hideLoading()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    LoadingView.shared.hideLoading()
                    
                    let error = NetworkManager.handle(error: error)
                    self?.showErrorAlert(with: Constants.Strings.error, message: error, completion: nil)
                }
            }
        }
    }
    
    func updateUserInfo() {
        dispatchGroup.enter()
        
        var newInfo = UserInfo()
        newInfo.firstName = nameTF.text
        newInfo.email = emailTF.text
        newInfo.phone = phoneNumberTF.text
        
        NetworkManager.shared.updateUserInfo(newInfo) { [weak self] (updateResult) in
            switch updateResult {
            case .success(_):
                self?.errorMsg = nil
            case .failure(let error):
                self?.errorMsg = NetworkManager.handle(error: error)
                break
            }
            
            self?.dispatchGroup.leave()
        }
    }
    
    func updateAvatar() {
        dispatchGroup.enter()
        
        NetworkManager.shared.updateAvatar(imageData!) { [weak self] (updateResult) in
            switch updateResult {
            case .success(_):
                break
            case .failure(_):
                break
            }
            
            self?.dispatchGroup.leave()
        }
    }
}

// MARK: - Picker
extension PersonalDataViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let img = info[.originalImage] as? UIImage {
            avatarImageView.image = img
            imageData = img.jpegData(compressionQuality: 1)
            saveButton.isEnabled = isChanged()
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func cameraAction() {
        func openCamera() {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let imagePicker = UIImagePickerController()
                imagePicker.delegate = self
                imagePicker.sourceType = .camera
                imagePicker.allowsEditing = false
                self.present(imagePicker, animated: true, completion: nil)
            }
        }
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            openCamera()
        case .notDetermined:
            print("notDetermined")
            AVCaptureDevice.requestAccess(for: .video) { (status) in
                DispatchQueue.main.async {
                    if status {
                        openCamera()
                    } else {
                        self.displayCameraAccessDeniedAlert()
                    }
                }
            }
        case .denied:
            displayCameraAccessDeniedAlert()
        default:
            break
        }
    }

    func galleryAction() {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
    private func displayCameraAccessDeniedAlert() {
        let alertController = UIAlertController(title: Constants.Strings.cameraAccess,
                                                message: Constants.Strings.cameraPermissionMessage,
                                                preferredStyle: .alert)
        let openSettingsAction = UIAlertAction(title: Constants.Strings.settings, style: .default) { (_) in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(openSettingsAction)
        
        alertController.addAction(UIAlertAction(title: Constants.Strings.cancel, style: UIAlertAction.Style.default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
}
