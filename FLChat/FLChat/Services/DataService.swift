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
    private var _REF_FRIEND_REQUEST = DB_BASE.child("friend_request")
    private var _REF_USER_FRIEND_REQUEST = DB_BASE.child("user_friend_request")
    
    // Path to user image folder in to firebase-storage
    private var _REF_STORAGE_BASE = STORAGE_BASE.child("profile_images")
    private var _REF_FRIENDS = DB_BASE.child("friends")
    private var _REF_USER_FRIENDS = DB_BASE.child("user_friends")
    private var _REF_MESSAGE = DB_BASE.child("messages")
    private var _REF_USER_MESSAGE = DB_BASE.child("users_messages")
    
    var REF_BASE: DatabaseReference {
        return _REF_BASE
    }
    
    var REF_USERS: DatabaseReference {
        return _REF_USERS
    }
    
    var REF_FRIEND_REQUEST: DatabaseReference {
        return _REF_FRIEND_REQUEST
    }
    
    var REF_USER_FRIEND_REQUEST: DatabaseReference {
        return _REF_USER_FRIEND_REQUEST
    }
    var REF_FRIENDS: DatabaseReference {
        return _REF_FRIENDS
    }
    
    var REF_USER_FRIENDS: DatabaseReference {
        return _REF_USER_FRIENDS
    }
    
    var REF_MESSAGE: DatabaseReference {
        return _REF_MESSAGE
    }
    
    var REF_USER_MESSAGE: DatabaseReference {
        return _REF_USER_MESSAGE
    }
    
    var REF_STORAGE_BASE: StorageReference {
        return _REF_STORAGE_BASE
    }
    
    func updateUserIntoDatabaseWithUID(_ uid: String, _ userData: Dictionary<String, Any>){
        REF_USERS.child(uid).updateChildValues(userData)
    }
    
    func updateDbImageUser(uid: String, userImage: Dictionary<String,Any>){
        REF_USERS.child(uid).updateChildValues(userImage)
    }
    
    func getAllFrinds(forSearchQuery query: String, _ completedSearching: @escaping (_ returnUsers: [Users]) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        var arrayUsers = [Users]()
        
        REF_USER_FRIENDS.child(uid).observe(.childAdded, with: { (snapshot) in
            
            let keyId = snapshot.key
            let requestReferense = self.REF_FRIENDS.child(keyId)
            requestReferense.observeSingleEvent(of: .value, with: { (snapshot) in
                
                // Switch around recipient users
                let switchUserRecipient: String!
                guard let dict = snapshot.value as? Dictionary<String,Any> else {return}
                let userUID = Auth.auth().currentUser?.uid
                if userUID == dict["fromId"] as? String {
                    switchUserRecipient = "toIdUser"
                }else{
                    switchUserRecipient = "fromIdUser"
                }
               
                let requestUser = requestReferense.child(switchUserRecipient)
                requestUser.observe(.value, with: { (snapshotToId) in
                    guard let dictionary = snapshotToId.value as? Dictionary<String,Any> else { return }
                    
                    let id = (dictionary["uid"] as? String)!
                    let name = (dictionary["name"] as? String)!
                    let image = (dictionary["image"] as? String)!
                    let email = (dictionary["email"] as? String)!
                    let phone = (dictionary["phone"] as? String)!
                    let status = (dictionary["online"] as? Bool)!
                    
                    if query == ""{
                        if email != Auth.auth().currentUser?.email {
                            let searchUserByEmail = Users(id, name, image, email, phone, status)
                            arrayUsers.append(searchUserByEmail)
                            completedSearching(arrayUsers)
                        }
                    }else{
                        if email.contains(query) && email != Auth.auth().currentUser?.email {
                            let searchUserByEmail = Users(id, name, image, email, phone, status)
                            arrayUsers.append(searchUserByEmail)
                            completedSearching(arrayUsers)
                        }
                    }
                }, withCancel: nil)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func getUserCredentialsFromDatabase(_ completeResponce: @escaping (_ getCredentials: Bool) -> ()){
       
        guard let uid = Auth.auth().currentUser?.uid else { return}
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            let value = snapshot.value as? Dictionary<String,Any>

            User.instance.phone = (value?["phone"] as? String)!
            User.instance.name = (value?["name"] as? String)!
            User.instance.email = (value?["email"] as? String)!
            User.instance.image = (value?["image"] as? String)!

            User.instance.online = (value?["online"] as? Bool)!
            User.instance.notificationOn = (value?["notificationOn"] as? Bool)!
            User.instance.notificationSoundOn = (value?["notificationSound"] as? Bool)!
            completeResponce(true)
        }
    }
   
    func getUsersWhomFriendRequestBeenSend(forSearchQuery query: String, completedSearching: @escaping (_ returnUsers: [Users]) -> ()){
        guard let fromId = Auth.auth().currentUser?.uid else { return }
        var arrayUsers = [Users]()
        REF_USER_FRIEND_REQUEST.child(fromId).observe(.childAdded, with: { (snapshot) in
            let toId = snapshot.key
            
            self.REF_USER_FRIEND_REQUEST.child(fromId).child(toId).observe(.childAdded, with: { (snapshot) in
                
                let requestId = snapshot.key
                let requestReferense = self.REF_FRIEND_REQUEST.child(requestId)
                requestReferense.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let requestUser = requestReferense.child("toIdUser")
                    requestUser.observe(.value, with: { (snapshotToId) in
                        guard let dictionary = snapshotToId.value as? Dictionary<String,Any> else { return }
                        
                        let name = (dictionary["name"] as? String)!
                        let image = (dictionary["image"] as? String)!
                        let email = (dictionary["email"] as? String)!
                        let phone = (dictionary["phone"] as? String)!
                        let status = (dictionary["online"] as? Bool)!
                        
                        if query == ""{
                            if email != Auth.auth().currentUser?.email {
                                let searchUserByEmail = Users(name, image, email, phone, status)
                                arrayUsers.append(searchUserByEmail)
                                completedSearching(arrayUsers)
                            }
                        }else{
                            if email.contains(query) && email != Auth.auth().currentUser?.email {
                                let searchUserByEmail = Users(name, image, email, phone, status)
                                arrayUsers.append(searchUserByEmail)
                                completedSearching(arrayUsers)
                            }
                        }
                    }, withCancel: nil)
                }, withCancel: nil)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func getUsersWhoSendRequestToFriends(forSearchQuery query: String, snapshotCompleted: @escaping(_ usersWhoSendRequest: [Users]) -> ()){
        let toId = (Auth.auth().currentUser?.uid)!
        var arrayUsers = [Users]()
        
        REF_USER_FRIEND_REQUEST.child(toId).observe(.childAdded, with: { (snapshot) in
            let fromId = snapshot.key
            self.REF_USER_FRIEND_REQUEST.child(toId).child(fromId).observe(.childAdded, with: { (snapshot) in
                let requestId = snapshot.key
                let requestReferense = self.REF_FRIEND_REQUEST.child(requestId)
                requestReferense.observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    let requestUser = requestReferense.child("fromIdUser")
                    requestUser.observe(.value, with: { (snapshotFromId) in
                        guard let dictionary = snapshotFromId.value as? Dictionary<String,Any> else { return }
                        
                        let uid = (dictionary["uid"] as? String)!
                        let name = (dictionary["name"] as? String)!
                        let image = (dictionary["image"] as? String)!
                        let email = (dictionary["email"] as? String)!
                        let phone = (dictionary["phone"] as? String)!
                        let status = (dictionary["online"] as? Bool)!
                        
                        if query == "" {
                            if email != Auth.auth().currentUser?.email {
                                let user = Users(uid, name, image, email, phone, status)
                                arrayUsers.append(user)
                                snapshotCompleted(arrayUsers)
                            }
                        }else{
                            if email.contains(query) && email != Auth.auth().currentUser?.email {
                                let user = Users(uid, name, image, email, phone, status)
                                arrayUsers.append(user)
                                snapshotCompleted(arrayUsers)
                            }
                        }
                    }, withCancel: nil)
                }, withCancel: nil)
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    func getUsersFromDatabase(forSearchQuery query: String, completedSearching: @escaping (_ userParametersArray: [Users]) -> ()){
        REF_USERS.observeSingleEvent(of: .value) { (allUserSnapshot) in
            
            var searchUser = [Users]()
            guard let userSnapshot = allUserSnapshot.children.allObjects as? [DataSnapshot] else { return }
            
            for user in userSnapshot{
                let userId = user.key
                let userName = user.childSnapshot(forPath: "name").value as! String
                let userImage = user.childSnapshot(forPath: "image").value as! String
                let userEmail = user.childSnapshot(forPath: "email").value as! String
                let userPhone = user.childSnapshot(forPath: "phone").value as! String
                let userStatus = user.childSnapshot(forPath: "online").value as! Bool
                
                if query == ""{
                    if userEmail != Auth.auth().currentUser?.email {
                        let searchUserByEmail = Users(userId, userName, userImage, userEmail, userPhone, userStatus)
                        searchUser.append(searchUserByEmail)
                    }
                }else{
                    if userEmail.contains(query) && userEmail != Auth.auth().currentUser?.email {
                        let searchUserByEmail = Users(userId, userName, userImage, userEmail, userPhone, userStatus)
                        searchUser.append(searchUserByEmail)
                    }
                }
            }
            completedSearching(searchUser)
        }
    }
    
    func removeFriendRequestsFromDatabase(_ toId: String, _ fromId: String, _ removeCompleted: @escaping (_ complete: Bool) -> ()){
        let refUFR = DataService.instance.REF_USER_FRIEND_REQUEST
        refUFR.child(toId).child(fromId).observe(.childAdded, with: { (snapshot) in
            refUFR.child(fromId).child(toId).observe(.childAdded, with: { (snapshot) in
                let key = snapshot.key
                let refFR = DataService.instance.REF_FRIEND_REQUEST.child(key)
                refFR.removeValue()
                refUFR.child(toId).child(fromId).removeValue()
                refUFR.child(fromId).child(toId).removeValue()
                removeCompleted(true)
            }, withCancel: nil)
        }, withCancel: nil)
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
                    let userData = self.userData(email, User.instance.phone, User.instance.name, url.absoluteString, User.instance.online, User.instance.notificationOn, User.instance.notificationSoundOn)
                    self.updateUserIntoDatabaseWithUID(uid, userData)
                    completedUserRegistration(true, nil)
                }
            }
        }
    }
    
    func friendRequestIntoDB(_ fromId: String, _ userFromId:Dictionary<String,Any>, _ toId: String, _ userToId:Dictionary<String,Any>, _ time: Double, _ msg: String, _ confirmReques: Bool, requestWillSend: @escaping(_ requestSend: Bool, _ autoKey: String) -> ()){
        let ref = REF_FRIEND_REQUEST.childByAutoId()
        let refAutoKey = ref.key!
        let value: Dictionary<String, Any> = ["fromId": fromId, "fromIdUser": userFromId, "toId": toId, "toIdUser": userToId, "timeStamp": time, "message": msg, "confirmReques": confirmReques]
        ref.updateChildValues(value)
        requestWillSend(true, refAutoKey)
    }
    
    func recipientsUserFriendRequestIntoDB(_ key: String, _ recipientId: String, recipientAddedIntoDatabase: @escaping(_ complete: Bool) -> ()){
        let toId = recipientId
        let fromId = (Auth.auth().currentUser?.uid)!
        let ref = REF_USER_FRIEND_REQUEST.child(toId).child(fromId)
        let requstId = "\(key)"
        let value: Dictionary<String, Any> = ["\(requstId)": 1]
        ref.updateChildValues(value) { (error, ref) in
            if error != nil{
                print("Can't create new object in to Database: \(String(describing: error?.localizedDescription))")
            }
            recipientAddedIntoDatabase(true)
        }
    }
    func userFriendRequestIntoDB(_ key: String, _ recipientId: String, _ requestSend: @escaping(_ requestSend: Bool)-> ()){
        let fromId = (Auth.auth().currentUser?.uid)!
        let toId = recipientId
        let ref = REF_USER_FRIEND_REQUEST.child(fromId).child(toId)
        let requstId = "\(key)"
        let value: Dictionary<String, Any> = ["\(requstId)": 1]
        ref.updateChildValues(value) { (error, ref) in
            if error != nil{
                print("Can't create new object in to Database: \(String(describing: error?.localizedDescription))")
            }
            requestSend(true)
        }
    }
    
    func friendIntoDB(_ fromId: String, _ userFromId:Dictionary<String,Any>, _ toId: String, _ userToId:Dictionary<String,Any>, _ time: Double, _ confirmReques: Bool, requestWillSend: @escaping(_ requestSend: Bool, _ autoKey: String) -> ()){
        let ref = REF_FRIENDS.childByAutoId()
        let refAutoKey = ref.key!
        let value: Dictionary<String, Any> = ["fromId": fromId, "fromIdUser": userFromId, "toId": toId, "toIdUser": userToId, "timeStamp": time, "confirmReques": confirmReques]
        ref.updateChildValues(value)
        requestWillSend(true, refAutoKey)
    }
    
   
    func recipientsUserFriendIntoDB(_ key: String, _ recipientId: String, refSend: @escaping(_ complete: Bool) -> ()){
        let uid = recipientId
        let ref = REF_USER_FRIENDS.child(uid)
        let requstId = "\(key)"
        let value: Dictionary<String, Any> = ["\(requstId)": 1]
        ref.updateChildValues(value) { (error, ref) in
            if error != nil{
                print("Can't create new object in to Database: \(String(describing: error?.localizedDescription))")
            }
            refSend(true)
        }
    }
    
    func userFriendIntoDB(_ key: String, refSend: @escaping(_ completed: Bool)-> ()){
        let uid = (Auth.auth().currentUser?.uid)!
        let ref = REF_USER_FRIENDS.child(uid)
        let friendId = "\(key)"
        let value: Dictionary<String, Any> = ["\(friendId)": 1]
        ref.updateChildValues(value) { (error, ref) in
            if error != nil{
                print("Can't create new object in to Database: \(String(describing: error?.localizedDescription))")
            }
            refSend(true)
        }
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
}
