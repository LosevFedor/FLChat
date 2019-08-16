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
import AVFoundation


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

        setUserSettings()
        imagePicker.delegate = self
    }
    
    func setUserSettings(){
        let uid = DataService.instance.REF_UID
        DataService.instance.getUserCredentialsDbFirebase(uid: uid) { (complete) in
            if complete {
                self.userNameLabel.text = User.instance.name
                self.userPhoneLabel.text = User.instance.phone
                
                let profileImageUrl = User.instance.image
                let url = URL(string: profileImageUrl)
                
                URLSession.shared.dataTask(with: url!, completionHandler: { (data, responce, error) in
                    if error != nil {
                        print("Cant convert the url for image: \(String(describing: error?.localizedDescription))")
                    }
                    DispatchQueue.main.async {
                        self.userImage.image = UIImage(data: data!)
                    }
                }).resume()
                
                self.switchValueSound.isOn = User.instance.notificationSound
                self.switchValueNotification.isOn = User.instance.notificationOn
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
            //UserDefaults.standard.removeLogIn()
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }catch let error as NSError{
            print("User can't SignOut: \(error.localizedDescription)")
        }
        
    }
    fileprivate func checkTextFieldForEpties(_ textField: String, _ defaultTitle: String) -> String {
        
        var usertextFieldParam = textField
        if usertextFieldParam == ""{
            usertextFieldParam = defaultTitle
        }
        return usertextFieldParam
    }
    
    @IBAction func changePhoneBtnPressed(_ sender: Any) {
        let alertController: UIAlertController = UIAlertController(title: "Change your phone number", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            self.userPhoneTextField = textField
            self.userPhoneTextField?.placeholder = "Enter your new phone number"
        }
        let okAlert = UIAlertAction(title: "OK", style: .cancel) { (okAction) in
            let uid = DataService.instance.REF_UID
            
            
            self.userPhoneTextField?.text = self.checkTextFieldForEpties(self.userPhoneTextField!.text!, DEFAULT_PHONE_FIELD)
            
            DataService.instance.changeUserPhoneIntoDatabaseWithUID(uid, (self.userPhoneTextField?.text)!) { (changed, error) in
                if error != nil {
                    print("Can't change user phone: \(String(describing: error?.localizedDescription))")
                }
                if changed{
                    self.setUserSettings()
                }
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        
        alertController.addAction(okAlert)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func changePasswordBtnPressed(_ sender: Any) {
    }
    
    @IBAction func changeEmailBtnPressed(_ sender: Any) {
    }
    
    @IBAction func changeNameBtnPressed(_ sender: Any) {
        
        let alertController: UIAlertController = UIAlertController(title: "Change your name", message: nil, preferredStyle: .alert)
        alertController.addTextField { (textField) in
            self.userNameTextField = textField
            self.userNameTextField?.placeholder = "Enter your new name"
        }
        let okAlert = UIAlertAction(title: "OK", style: .cancel) { (okAction) in
            let uid = DataService.instance.REF_UID
            
            self.userNameTextField?.text = self.checkTextFieldForEpties(self.userNameTextField!.text!, DEFAULT_NAME_FIELD)
            
            DataService.instance.changeUserNameIntoDatabaseWithUID(uid, (self.userNameTextField?.text)!) { (changed, error) in
                if error != nil {
                    print("Can't change user name: \(String(describing: error?.localizedDescription))")
                }
                if changed{
                    self.setUserSettings()
                }
            }
        }
        let cancelAlert = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(okAlert)
        alertController.addAction(cancelAlert)
        
        present(alertController, animated: true, completion: nil)
    }
    
   
    @IBAction func pushNotificationSoundBtnPressed(_ sender: Any) {
    }
    
    @IBAction func pushNotificationBtnPressed(_ sender: Any) {
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
            uploadNewUserImageIntoDatabase(selectedImage) { (updated, error) in
                if updated{
                    self.setUserSettings()
                }
            }
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    private func uploadNewUserImageIntoDatabase(_ image: UIImage, copletedUpdateURLIntoDatabase: @escaping(_ update: Bool, _ error: Error?) -> ()){
        let uid = DataService.instance.REF_UID
        let ref = DataService.instance.REF_STORAGE_BASE.child(uid)
        
        if let uploadData = image.jpegData(compressionQuality: COMPRESSION_IMAGE){
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil{
                    print("Failed to upload image:\(String(describing: error?.localizedDescription))")
                }
                
                ref.downloadURL { (url, error) in
                    guard let url = url else{
                        copletedUpdateURLIntoDatabase(false, error)
                        return
                    }
                    let userData = DataService.instance.changeUserImage(url.absoluteString)
                    DataService.instance.updateUserIntoDatabaseWithUID(uid, userData)
                    copletedUpdateURLIntoDatabase(true, nil)
                }
            }
        }
    }
    
}
