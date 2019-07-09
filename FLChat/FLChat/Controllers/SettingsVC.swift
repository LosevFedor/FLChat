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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SignOutPressed(_ sender: Any) {
        do{
            try Auth.auth().signOut()
            GIDSignIn.sharedInstance()?.signOut()
            UserDefaults.standard.setIsLoggedIn(value: false)
            view.window?.rootViewController?.dismiss(animated: true, completion: nil)
        }catch let error as NSError{
            print("User can't SignOut: \(error.localizedDescription)")
        }
        
    }
    
}
