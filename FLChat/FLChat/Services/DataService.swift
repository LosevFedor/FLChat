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
    private var _REF_STORAGE_BASE = STORAGE_BASE.child("profile_images")
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
    
    func updateUserIntoDatabaseWithUID(_ uid: String, _ userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateDbImageUser(uid: String, userImage: Dictionary<String,Any>){
        REF_USERS.child(uid).updateChildValues(userImage)
    }
    
    
    func getUserCredentialsDbFirebase(uid: String, completedSnapshot: @escaping (_ snapshot: Bool) -> ()){
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? Dictionary<String,Any>

            User.instance.phone = (value?["phone"] as? String)!
            User.instance.name = (value?["name"] as? String)!
            
            User.instance.image = (value?["image"] as? String)!

            User.instance.online = (value?["online"] as? Bool)!
            User.instance.notificationOn = (value?["notificationOn"] as? Bool)!
            User.instance.notificationSound = (value?["notificationSound"] as? Bool)!
            
            completedSnapshot(true)
        }
        completedSnapshot(false)
    }

    func changeUserImage(_ userImage: String) -> Dictionary<String,Any>{
        let dictUserImage = ["image": userImage]
        return dictUserImage
    }
    
    private func userData(_ email: String, _ phone: String, _ name: String, _ image: String, _ online: Bool, _ notificationOn: Bool, _ notificationSound: Bool) -> Dictionary<String,Any>{
        let dictUserParams = ["phone": phone, "name": name, "image": image, "email": email, "online": online, "notificationOn": notificationOn, "notificationSound": notificationSound] as [String : Any]
        return dictUserParams
    }
    
    private func changeUserName(_ userName: String) -> Dictionary<String,Any>{
        let dictUserName = ["name": userName]
        return dictUserName
    }
    
    private func changeUserPhone(_ userPhone: String) -> Dictionary<String,Any>{
        let dictUserPhone = ["phone": userPhone]
        return dictUserPhone
    }
    
    private func changeUsserNotificationSound(_ userNotificationSound: Bool) -> Dictionary<String,Any>{
        let dictUserNotificationSound = ["notificationSound": userNotificationSound]
        return dictUserNotificationSound
    }
    
    private func changeUserPushNotification(_ userPushNotification: Bool) -> Dictionary<String, Any>{
        let dictUserPushNotification = ["notificationOn": userPushNotification]
        return dictUserPushNotification
    }
    
    func registrationUserIntoDatabase(_ uid: String, _ email: String, completedUserRegistration: @escaping (_ registration:Bool, _ error:Error?) -> ()){
        let ref = REF_STORAGE_BASE.child(uid)
        let defaultUserImage = UIImage(named:  "defaultImage")
        
        if let uploadImage = defaultUserImage?.jpegData(compressionQuality: COMPRESSION_IMAGE){
            ref.putData(uploadImage, metadata: nil) { (metadata, error) in
                if error != nil{
                    print("Can't upload image: \(String(describing: error?.localizedDescription))")
                }
                
                ref.downloadURL { (url, error) in
                    guard let url = url else{
                        completedUserRegistration(false,error)
                        return
                    }
                    let userData = self.userData(email, User.instance.phone, User.instance.name, url.absoluteString, User.instance.online, User.instance.notificationOn, User.instance.notificationSound)
                    self.updateUserIntoDatabaseWithUID(uid, userData)
                    completedUserRegistration(true, nil)
                }
            }
        }
    }
    
    func changeUserNameIntoDatabaseWithUID(_ uid: String, _ newUserName: String, copletedChangeUserName: @escaping(_ changed:Bool, _ error:Error?) -> ()){
        let userData = changeUserName(newUserName)
        self.updateUserIntoDatabaseWithUID(uid, userData)
        copletedChangeUserName(true,nil)
    }
    
    func changeUserPhoneIntoDatabaseWithUID(_ uid: String, _ newUserPhone: String, completedChangeUserPhone: @escaping(_ change:Bool, _ error:Error?) -> ()){
        let userData = changeUserPhone(newUserPhone)
        self.updateUserIntoDatabaseWithUID(uid, userData)
        completedChangeUserPhone(true,nil)
    }
    
    func changeUserNotificationSoundIntoDatabaseWithUID(_ uid: String, _ newUserNotificationSound: Bool, completedChangeUserNotificationSound: @escaping(_ change:Bool, _ error: Error?) -> ()){
        let userData = changeUsserNotificationSound(newUserNotificationSound)
        self.updateUserIntoDatabaseWithUID(uid, userData)
        completedChangeUserNotificationSound(true,nil)
    }
    
    func changeUserPushNotificationIntoDatabaseWithUID(_ uid: String, _ newUserPushNotification: Bool, completedChangeUserPushNotification: @escaping(_ change:Bool, _ error: Error?) -> ()){
        let userData = changeUserPushNotification(newUserPushNotification)
        self.updateUserIntoDatabaseWithUID(uid, userData)
        completedChangeUserPushNotification(true,nil)
    }
}
