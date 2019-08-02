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
    
    private var _name: String?
    private var _image: String?
    private var _online: Bool?
    private var _notificationOn: Bool?
    private var _notificationSound: Bool?
    private var _phone: String?
    
    var phone: String{
        get{
            return _phone!
        }
        set{
            _phone = newValue
        }
    }
    
    var name: String{
        get{
            return _name!
        }set{
            _name = newValue
        }
    }
    
    var image: String{
        get{
            return _image!
        }set{
            _image = newValue
        }
    }
    
    var online: Bool{
        get{
            return _online!
        }set{
            _online = newValue
        }
    }
    
    var notificationOn: Bool{
        get{
            return _notificationOn!
        }set{
            _notificationOn = newValue
        }
    }
    
    var notificationSound: Bool{
        get{
            return _notificationSound!
        }set{
            _notificationSound = newValue
        }
    }
    
    
    
//
//    init() {
//        _phone = "Your phone number"
//        _name = "Your name"
//        _image = "empty field"
//        _online = true
//        _notificationOn = true
//        _notificationSound = true
//    }
    
}
