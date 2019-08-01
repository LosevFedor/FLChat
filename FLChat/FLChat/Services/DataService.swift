//
//  DataService.swift
//  FLChat
//
//  Created by Softomate on 7/15/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation
import Firebase
import UIKit

let DB_BASE = Database.database().reference()

class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        print("_REF_USERS \(_REF_USERS)")
        return _REF_USERS
    }
    
    func createFirebaseDBUser(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateDbImageUser(uid: String, userImage: Dictionary<String,Any>){
        REF_USERS.child(uid).updateChildValues(userImage)
    }

    
    func userData(_ email: String, _ phone: String, _ name: String, _ image: String, _ online: Bool, _ notificationOn: Bool, _ notificationSound: Bool) -> Dictionary<String,Any>{
        let dictUserParams = ["phone": phone, "name": name, "email": email, "image": image, "online": online, "notificationOn": notificationOn, "notificationSound": notificationSound] as [String : Any]
        return dictUserParams
    }
    
    func changeUserImage(_ userImage: String) -> Dictionary<String,Any>{
        let dictUserImage = ["image": userImage]
        return dictUserImage
    }
}
