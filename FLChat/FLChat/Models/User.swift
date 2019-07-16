//
//  Users.swift
//  FLChat
//
//  Created by Softomate on 7/16/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation

struct User{
    
    static var instance = User()
    
    private var _name: String?
    private var _image: String?
    private var _email: String?
    private var _online: Bool?
    private var _notificationOn: Bool?
    private var _notificationSound: Bool?
    
    var name: String{
        get{
            return _name!
        }set{
            _name = newValue
        }
    }
    
    var email: String{
        get{
            return _email!
        }set{
            _email = newValue
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
    
    
    mutating func userData(_ email: String) -> Dictionary<String,Any>{
        self.name = "Enter your name"
        self.email = email
        self.image = "empty field"
        self.online = true
        self.notificationOn = true
        self.notificationSound = true

        let dictionaryUserParameters = ["name": name, "email": email, "image": image, "online": online, "notificationOn": notificationOn, "notificationSound": notificationSound] as [String : Any]
        return dictionaryUserParameters
    }
}
