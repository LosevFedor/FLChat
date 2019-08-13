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
let STORAGE_BASE = Storage.storage().reference()

class DataService {
    
    static let instance = DataService()
    
    private var _REF_BASE = DB_BASE
    private var _REF_USERS = DB_BASE.child("users")
    
    // Path to user image folder in to firebase-storage
    private var _REF_STORAGE_BASE = STORAGE_BASE.child("user_image")

    
    // Unique user identification
    private var _REF_UID = Auth.auth().currentUser?.uid
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_STORAGE_BASE: StorageReference {
        return _REF_STORAGE_BASE
    }
    
    var REF_UID: String {
        return _REF_UID!
    }
    
    func updateUserIntoBatabaseWithUID(uid: String, userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateDbImageUser(uid: String, userImage: Dictionary<String,Any>){
        REF_USERS.child(uid).updateChildValues(userImage)
    }
    
    
    func getUserCredentialsDbFirebase(uid: String, completion: @escaping (_ completionSnapshot: Bool) -> ()){
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in

            let value = snapshot.value as? Dictionary<String,Any>

            User.instance.phone = (value?["phone"] as? String)!
            User.instance.name = (value?["name"] as? String)!
            
            User.instance.image = (value?["image"] as? String)!

            User.instance.online = (value?["online"] as? Bool)!
            User.instance.notificationOn = (value?["notificationOn"] as? Bool)!
            User.instance.notificationSound = (value?["notificationSound"] as? Bool)!
        }
    }

    
    func userData(_ email: String, _ phone: String, _ name: String, _ image: String, _ online: Bool, _ notificationOn: Bool, _ notificationSound: Bool) -> Dictionary<String,Any>{
        let dictUserParams = ["phone": phone, "name": name, "image": image, "email": email, "online": online, "notificationOn": notificationOn, "notificationSound": notificationSound] as [String : Any]
        return dictUserParams
    }
    
    func changeUserImage(_ userImage: String) -> Dictionary<String,Any>{
        let dictUserImage = ["image": userImage]
        return dictUserImage
    }
    
    func registerUserIntoDatabase(_ uid: String, _ email: String){
        let ref = REF_STORAGE_BASE.child(uid)
        let defaultUserImage = UIImage(named:  "defaultImage")
        if let uploadImage = defaultUserImage?.jpegData(compressionQuality: 0.2){
            ref.putData(uploadImage, metadata: nil) { (metadata, error) in
                if error != nil{
                    print("Can't upload image: \(String(describing: error?.localizedDescription))")
                }
                
                ref.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print("can't get absolute URL string from firebase: \(String(describing: error?.localizedDescription))")
                    }
                    
                    let ud = self.userData(email, User.instance.phone, User.instance.name, url!.absoluteString, User.instance.online, User.instance.notificationOn, User.instance.notificationSound)
                    
                    self.updateUserIntoBatabaseWithUID(uid: uid, userData: ud)
                })
                
            }
        }
    }
    
    func getUserSettings(){}
}
