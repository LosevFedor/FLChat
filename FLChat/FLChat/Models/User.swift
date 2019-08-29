//
//  Users.swift
//  FLChat
//
//  Created by Softomate on 7/16/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation
import UIKit

struct User {
    
    static var instance = User()
    
    //private var _userId = "default id"
    
    private var _name = "Your name"
    private var _image = "User image"
    private var _phone = "Your phone number"
    private var _email = "default@email.com"
    
    private var _statusOnline = true
    private var _notificationOn = true
    private var _notificationSound = true
    
//    var userId: String {
//        get{
//            return _userId
//        }
//    }
    
    var phone: String{
        get{
            return _phone
        }
        set{
            _phone = newValue
        }
    }
    
    var name: String{
        get{
            return _name
        }set{
            _name = newValue
        }
    }
    
    var image: String{
        get{
            return _image
        }set{
            _image = newValue
        }
    }
    
    var email: String {
        get{
            return _email
        }set{
            _email = newValue
        }
    }
    
    var statusOnline: Bool{
        get{
            return _statusOnline
        }set{
            _statusOnline = newValue
        }
    }
    
    var notificationOn: Bool{
        get{
            return _notificationOn
        }set{
            _notificationOn = newValue
        }
    }
    
    var notificationSound: Bool{
        get{
            return _notificationSound
        }set{
            _notificationSound = newValue
        }
    }
}
