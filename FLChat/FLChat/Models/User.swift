//
//  Users.swift
//  FLChat
//
//  Created by Softomate on 7/16/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation
import UIKit

class User: NSObject{
    static var instance = User()
    
    var name: String = "User name"
    var image: String = "User image"
    var phone: String = "User phone"
    var email: String = "User email"
    var online: Bool = true
    var notificationOn: Bool = true
    var notificationSoundOn: Bool = true
    
    deinit {
        print("User: all referenses was remove")
    }
    
    func resetUserSettingsToDefault(){
        name = "User name"
        image = "User image"
        phone = "User phone"
        email = "User email"
        online = true
        notificationOn = true
        notificationSoundOn = true
    }
}
