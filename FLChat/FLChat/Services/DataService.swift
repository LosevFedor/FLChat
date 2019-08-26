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
    private var _REF_FRIEND_REQUEST = DB_BASE.child("friend_request").childByAutoId()
    // Path to user image folder in to firebase-storage
    private var _REF_STORAGE_BASE = STORAGE_BASE.child("profile_images")
    // Unique user identification
    private var _REF_UID = Auth.auth().currentUser?.uid
    private var _REF_EMAIL = Auth.auth().currentUser?.email
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_FRIEND_REQUEST: DatabaseReference {
        return _REF_FRIEND_REQUEST
    }
    
    var REF_STORAGE_BASE: StorageReference {
        return _REF_STORAGE_BASE
    }
    
    var REF_UID: String {
        return _REF_UID!
    }
    
    var REF_EMAIL: String {
        return _REF_EMAIL!
    }
    
    func updateUserIntoDatabaseWithUID(_ uid: String, _ userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateDbImageUser(uid: String, userImage: Dictionary<String,Any>){
        REF_USERS.child(uid).updateChildValues(userImage)
    }
    
    
    func getUserCredentialsFromDatabase(uid: String, completedSnapshot: @escaping (_ snapshot: Bool) -> ()){
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? Dictionary<String,Any>

            User.instance.phone = (value?["phone"] as? String)!
            User.instance.name = (value?["name"] as? String)!
            User.instance.email = (value?["email"] as? String)!
            User.instance.image = (value?["image"] as? String)!

            User.instance.statusOnline = (value?["online"] as? Bool)!
            User.instance.notificationOn = (value?["notificationOn"] as? Bool)!
            User.instance.notificationSound = (value?["notificationSound"] as? Bool)!
            
            completedSnapshot(true)
        }
        completedSnapshot(false)
    }
    
    
    func getAllUsersFromDatabase(completedSnapshotAllUsers: @escaping (_ allUsers: [AllUsers], _ error: Error?) -> ()){
        REF_USERS.observeSingleEvent(of: .value) { (allUsersSnapshot) in
            
            var allUsersArray = [AllUsers]()
            guard let allUsersSnapshot = allUsersSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in allUsersSnapshot{
                
                let userId = user.key
                let userName = user.childSnapshot(forPath: "name").value as! String
                let userImage = user.childSnapshot(forPath: "image").value as! String
                let userEmail = user.childSnapshot(forPath: "email").value as! String
                let userPhone = user.childSnapshot(forPath: "phone").value as! String
                let userStatus = user.childSnapshot(forPath: "online").value as! Bool
                
                if userEmail != self.REF_EMAIL {
                    let user = AllUsers(userId, userName, userImage, userEmail, userPhone, userStatus)
                    allUsersArray.append(user)
                }
            }
            completedSnapshotAllUsers(allUsersArray, nil)
        }
    }
    
    func getUserByEmailFromDatabase(forSearchQuery query: String, completedSearching: @escaping (_ userParametersArray: [AllUsers]) -> ()){
        REF_USERS.observeSingleEvent(of: .value) { (allUserSnapshot) in
            
            var searchUser = [AllUsers]()
            guard let userSnapshot = allUserSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot{
                let userId = user.key
                let userName = user.childSnapshot(forPath: "name").value as! String
                let userImage = user.childSnapshot(forPath: "image").value as! String
                let userEmail = user.childSnapshot(forPath: "email").value as! String
                let userPhone = user.childSnapshot(forPath: "phone").value as! String
                let userStatus = user.childSnapshot(forPath: "online").value as! Bool
                
                if userEmail.contains(query) && userEmail != self.REF_EMAIL {
                    let searchUserByEmail = AllUsers(userId, userName, userImage, userEmail, userPhone, userStatus)
                    searchUser.append(searchUserByEmail)
                }
            }
            completedSearching(searchUser)
        }
        
        
        
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
    
    func registrationUserIntoDB(_ uid: String, _ email: String, completedUserRegistration: @escaping (_ registration:Bool, _ error:Error?) -> ()){
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
                    let userData = self.userData(email, User.instance.phone, User.instance.name, url.absoluteString, User.instance.statusOnline, User.instance.notificationOn, User.instance.notificationSound)
                    self.updateUserIntoDatabaseWithUID(uid, userData)
                    completedUserRegistration(true, nil)
                }
            }
        }
    }
    
    func createRequestAddFriendIntoDB(_ fromUser: String, _ toUser: String, _ time: Double, _ msg: String, _ fromUserParams: Dictionary<String,Any>, _ toUserParams: Dictionary<String,Any>){
        let ref = DataService.instance.REF_FRIEND_REQUEST
        
        let fromId = fromUser
        let toId = toUser
        let timeStamp = time
        let msgRequest = msg
        
        let fromUserParams = fromUserParams
        let toUserParams = toUserParams
        
        let value: Dictionary<String, Any> = ["fromId": fromId, "toId": toId, "timeStamp": timeStamp, "message": msgRequest, "fromUserParams": fromUserParams, "toUserParams": toUserParams]
        ref.updateChildValues(value)
    }
    
    func changeUserNameIntoDatabaseWithUID(_ uid: String, _ newUserName: String, copletedChangeUserName: @escaping(_ changed:Bool, _ error:Error?) -> ()){
        let userData = changeUserName(newUserName)
        self.updateUserIntoDatabaseWithUID(uid, userData)
        copletedChangeUserName(true,nil)
    }
    
    func changeUserPhoneIntoDBWithUID(_ uid: String, _ newUserPhone: String, completedChangeUserPhone: @escaping(_ change:Bool, _ error:Error?) -> ()){
        let userPhone = changeUserPhone(newUserPhone)
        self.updateUserIntoDatabaseWithUID(uid, userPhone)
        completedChangeUserPhone(true,nil)
    }
    
    func changeUserNotificationSoundIntoDatabaseWithUID(_ uid: String, _ newUserNotificationSound: Bool, completedChangeUserNotificationSound: @escaping(_ change:Bool, _ error: Error?) -> ()){
        let userNotificationSound = changeUsserNotificationSound(newUserNotificationSound)
        self.updateUserIntoDatabaseWithUID(uid, userNotificationSound)
        completedChangeUserNotificationSound(true,nil)
    }
    
    func changeUserPushNotificationIntoDatabaseWithUID(_ uid: String, _ newUserPushNotification: Bool, completedChangeUserPushNotification: @escaping(_ change:Bool, _ error: Error?) -> ()){
        let userPushNotification = changeUserPushNotification(newUserPushNotification)
        self.updateUserIntoDatabaseWithUID(uid, userPushNotification)
        completedChangeUserPushNotification(true,nil)
    }
    
//    func getImageURLFromDB(_ uid: String, _ image: UIImage, complete: @escaping (_ isUrl: Bool) -> ()) -> String {
//        
//        let ref = DataService.instance.REF_STORAGE_BASE.child(uid)
//        var convertedImageString = ""
//        ref.downloadURL { (url, error) in
//            guard let url = url else { return }
//            convertedImageString = url.absoluteString
//            complete(true)
//        }
//        return convertedImageString
//    }
}
