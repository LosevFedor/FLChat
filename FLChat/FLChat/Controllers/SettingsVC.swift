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

class SettingsVC: UIViewController {
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userPhoneLabel: UILabel!
    
    @IBOutlet weak var pushNotificationSoundLabel: UILabel!
    @IBOutlet weak var pushNotificationLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUserSettings()
        
    }
    
    func setUserSettings(){
        
        let userName = Auth.auth().currentUser?.displayName
        print(userName)
        userNameLabel.text = User.instance.name
        userPhoneLabel.text = User.instance.phone
        userImage.image = #imageLiteral(resourceName: "defaultImage")
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
    @IBAction func addPhoneBtnPressed(_ sender: Any) {
    }
    
    @IBAction func changePasswordBtnPressed(_ sender: Any) {
    }
    
    @IBAction func changeEmailBtnPressed(_ sender: Any) {
    }
    
    @IBAction func changeNameBtnPressed(_ sender: Any) {
    }
    
    @IBAction func pushNotificationSoundBtnPressed(_ sender: Any) {
    }
    
    @IBAction func pushNotificationBtnPressed(_ sender: Any) {
    }
    
    @IBAction func changeUserImage(_ Sender: Any){
        let changeImageVC = ChangeImageVC()
        changeImageVC.modalPresentationStyle = .custom
        present(changeImageVC, animated: true, completion: nil)
    }
}
