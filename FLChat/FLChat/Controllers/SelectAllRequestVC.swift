//
//  SelectAllRequestFriendsVC.swift
//  FLChat
//
//  Created by Fedor Losev on 04/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import Firebase

class SelectAllRequestFriendsVC: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    
    @IBOutlet weak var backgroundUserImg: UIImageView!
    @IBOutlet weak var userImg: DesigneImage!
    
    private var currentBackgroundUserImg:UIImage!
    private var currentUID: String!
    private var currentUserName:String!
    private var currentUserImage: UIImage!
    private var currentUserEmail:String!
    private var currentUserPhone:String!
    private var currentUserStatus: Bool!
    private var currentUserUrlImage: String!
    
    fileprivate func addBlureEffeckForBackgroundUserImg() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = backgroundUserImg.bounds
        backgroundUserImg.addSubview(blurView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = currentUserName
        userImg.image = currentUserImage
        userEmail.text = "Email: \(currentUserEmail!)"
        userPhone.text = "Phone: \(currentUserPhone!)"
        
        let status = convertUserStatusToString(currentUserStatus)
        
        userStatus.text = status
        backgroundUserImg.image = currentBackgroundUserImg
        
        addBlureEffeckForBackgroundUserImg()
    }
    
    func initData(_ id: String, _ name: String, _ image: UIImage, _ email: String, _ phone: String, _ status: Bool, _ urlImage: String){
        currentUID = id
        currentUserName = name
        currentUserImage = image
        currentBackgroundUserImg = image
        currentUserEmail = email
        currentUserPhone = phone
        currentUserStatus = status
        currentUserUrlImage = urlImage
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    private func convertUserStatusToString(_ userStatus: Bool) -> String{
        let status: String!
        if userStatus {
            status = "online"
        }else{
            status = "ofline"
        }
        return status
    }
    @IBAction func addUsertoFriendsBtnPressed(_ sender: Any) {
        let toId = (Auth.auth().currentUser?.uid)!
        let fromId = currentUID!
        let timeStamp = Double(NSDate().timeIntervalSince1970)
        let userTo = getParamsUserTo()
        let userFrom = getParamsUserFrom()
        let confirmReques = true
        
        DataService.instance.friendIntoDB(fromId, userFrom, toId, userTo, timeStamp, confirmReques) { (addedToFriends, autoKey) in
            if addedToFriends{
                DataService.instance.userFriendIntoDB(autoKey, refSend: { (created) in
                    if created {
                        DataService.instance.recipientsUserFriendIntoDB(autoKey, fromId, refSend: { (created) in
                            if created {
                                DataService.instance.removeFriendRequestsFromDatabase(toId, fromId, { (coplete) in
                                    if coplete {
                                        let alertController = UIAlertController(title: "You have successfully added the user: \"\(self.currentUserName!)\" to your friends list.", message: nil, preferredStyle: .alert)
                                        let okAlert = UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
                                            self.dismiss(animated: true, completion: nil)
                                        })
                                        alertController.addAction(okAlert)
                                        self.present(alertController, animated: true, completion: nil)
                                    }
                                })
                            }
                        })
                    }
                })
            }
        }
    }
    
    private func addRecipienceIntoDb(_ key: String, _ fromId: String){
        //var updateDb = false
        DataService.instance.recipientsUserFriendIntoDB(key, fromId, refSend: { (created) in
            if created{
                let alertController = UIAlertController(title: "You have successfully added the user: \"\(self.currentUserName!)\" to your friends list.", message: nil, preferredStyle: .alert)
                let okAlert = UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
                    self.dismiss(animated: true, completion: nil)
                })
                alertController.addAction(okAlert)
                self.present(alertController, animated: true, completion: nil)
                //updateDb = true
            }
        })
        //return updateDb
    }
    
    private func getParamsUserTo() -> Dictionary<String,Any>{
        let uid = (Auth.auth().currentUser?.uid)!
        let name = User.instance.name
        let image = User.instance.image
        let email = User.instance.email
        let phone = User.instance.phone
        let status = User.instance.online
        let user:Dictionary<String,Any> = ["uid": uid, "name": name, "image": image, "email": email, "phone": phone, "online": status]
        return user
    }
    
    private func getParamsUserFrom() -> Dictionary<String,Any>{
        let user:Dictionary<String,Any> = ["uid": currentUID!, "name": currentUserName!, "image": currentUserUrlImage!, "email": currentUserEmail!, "phone": currentUserPhone!, "online": currentUserStatus!]
        return user
    }
}
