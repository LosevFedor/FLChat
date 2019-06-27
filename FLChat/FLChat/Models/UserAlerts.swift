//
//  UserAlerts.swift
//  FLChat
//
//  Created by Softomate on 6/27/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation
import UIKit

struct UserAlerts{
    
    static let inctance = UserAlerts()
    private init() {}
    
    func IncorrecnLoginPassword(_ alert:UIAlertController, _ title: String, _ message: String){
        alert.addAction(UIAlertAction.init(title: "Yes", style: .cancel, handler: { (action) in
            LogInUser.instance.logIn(LoginVC.instance.emailField.text!, LoginVC.instance.passwordField.text!)
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Try again", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
    }
}
