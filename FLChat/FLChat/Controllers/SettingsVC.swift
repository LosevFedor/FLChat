//
//  SettingsVC.swift
//  FLChat
//
//  Created by Fedor Losev on 09/07/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FBSDKLoginKit
//import AVFoundation


class SettingsVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    
    @IBOutlet weak var switchValueSound: UISwitch!
    @IBOutlet weak var switchValueNotification: UISwitch!
    
    @IBOutlet weak var pushNotificationSoundLabel: UILabel!
    @IBOutlet weak var pushNotificationLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    
    var userNameTextField: UITextField?
    var userPhoneTextField: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setUserSettings()
    }
    
    deinit {
        print("SettingsView: all referenses was remove")
    }
    
    func setUserSettings(){
        DataService.instance.getUserCredentialsFromDatabase{ [weak self] (userParams) in
            if userParams{
                let currentName = User.instance.name
                let currentPhone = User.instance.phone
                let currentImage = User.instance.image
                let currentNotificationSound = User.instance.notificationSoundOn
                let currentNotificationOn = User.instance.notificationOn
                
                self?.userNameLabel.text = currentName
                self?.userPhoneLabel.text = currentPhone
                self?.userImage.loadImageUsingCacheWithUrlString(currentImage)
                self?.switchValueSound.isOn = currentNotificationSound
                self?.switchValueNotification.isOn = currentNotificationOn
            }
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SignOutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            UserDefaults.standard.setIsLoggedIn(value: false)
            User.instance.resetUserSettingsToDefault()
            
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }catch let error as NSError{
            print("User can't SignOut: \(error.localizedDescription)")
        }
        
    }
    
    fileprivate func textFieldIsEmpty(_ textField: String, _ defaultTitle: String) -> String {
        var usertextFieldParam = textField
        
        if usertextFieldParam == ""{
            usertextFieldParam = defaultTitle
        }
        
        return usertextFieldParam
    }
    
    @IBAction func changePhoneBtnPressed(_ sender: Any) {
        let alertController: UIAlertController = UIAlertController(title: "Change your phone number", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { [weak self] (textField) in
            self?.userPhoneTextField = textField
            self?.userPhoneTextField?.placeholder = "Enter your new phone number"
        }
        
        let okAlert = UIAlertAction(title: "OK", style: .cancel) { [weak self] (okAction) in
            let uid = (Auth.auth().currentUser?.uid)!
            
            self?.userPhoneTextField?.text = self?.textFieldIsEmpty((self?.userPhoneTextField!.text)!, DEFAULT_PHONE_FIELD)
            
            DataService.instance.changeUserPhoneIntoDBWithUID(uid, (self?.userPhoneTextField?.text)!) { [weak self] (changed, error) in
                if error != nil {
                    print("Can't change user phone: \(String(describing: error?.localizedDescription))")
                }
                if changed{
                    self?.setUserSettings()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(okAlert)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func changeNameBtnPressed(_ sender: Any) {
        
        let alertController: UIAlertController = UIAlertController(title: "Change your name", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { [weak self] (textField) in
            self?.userNameTextField = textField
            self?.userNameTextField?.placeholder = "Enter your new name"
        }
        
        let okAlert = UIAlertAction(title: "OK", style: .cancel) { [weak self] (okAction) in
            let uid = (Auth.auth().currentUser?.uid)!
            
            self?.userNameTextField?.text = self?.textFieldIsEmpty((self?.userNameTextField!.text!)!, DEFAULT_NAME_FIELD)
            
            DataService.instance.changeUserNameIntoDatabaseWithUID(uid, (self?.userNameTextField?.text)!) { [weak self] (changed, error) in
                if error != nil {
                    print("Can't change user name: \(String(describing: error?.localizedDescription))")
                }
                if changed{
                    self?.setUserSettings()
                }
            }
        }
        
        let cancelAlert = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(okAlert)
        alertController.addAction(cancelAlert)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func pushNotificationSoundBtnPressed(_ sender: Any) {
        let soundOn = self.switchValueSound.isOn
        let uid = (Auth.auth().currentUser?.uid)!
        DataService.instance.changeUserNotificationSoundIntoDatabaseWithUID(uid, soundOn) { [weak self] (changeSound, error) in
            if error != nil{
                print("Can't change user notification in to database")
            }
            if changeSound{
                self?.setUserSettings()
            }
        }
    }
    
    @IBAction func pushNotificationBtnPressed(_ sender: Any) {
        let pushNotificationOn = switchValueNotification.isOn
        let uid = (Auth.auth().currentUser?.uid)!
        DataService.instance.changeUserPushNotificationIntoDatabaseWithUID(uid, pushNotificationOn) { [weak self] (changePush, error) in
            if error != nil{
                print("Can't change user push notification in to database \(String(describing: error?.localizedDescription))")
            }
            if changePush{
                self?.setUserSettings()
            }
        }
    }
    
    @IBAction func changeUserImage(_ Sender: Any){
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
}

extension SettingsVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker:UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            uploadNewUserImageToDB(selectedImage) { [weak self] (uploadedUserImage) in
                if uploadedUserImage{
                    self?.setUserSettings()
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    private func uploadNewUserImageToDB(_ image: UIImage, completion: @escaping(_ upload: Bool) -> ()){
        let uid = (Auth.auth().currentUser?.uid)!
        let ref = DataService.instance.REF_STORAGE_PROFILE_IMAGES.child(uid)
        
        if let uploadData = image.jpegData(compressionQuality: COMPRESSION_IMAGE){
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil{
                    print("Failed to upload image:\(String(describing: error?.localizedDescription))")
                }
                
                ref.downloadURL { (url, error) in
                    guard let url = url else{
                        completion(false)
                        return
                    }
                    let newUserImage = DataService.instance.changeUserImage(url.absoluteString)
                    DataService.instance.updateUserIntoDatabaseWithUID(uid, newUserImage)
                    completion(true)
                }
            }
        }
    }
    
}
