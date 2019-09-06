//
//  SelectNewUserFriendVC.swift
//  FLChat
//
//  Created by Fedor Losev on 23/08/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import Firebase

class SelectNewUserFriendVC: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var userDescriptionText: UILabel!
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
    private var currentUserWhatYouCanToDo: String!
    private var currentUserHasTextForButton: String!
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
        userDescriptionText.text = currentUserWhatYouCanToDo
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
        currentUserWhatYouCanToDo = "You don't have this is person in to your friends"
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendFrienRequestBtnPressed(_ sender: Any){
        let toId = currentUID!
        let fromId = (Auth.auth().currentUser?.uid)!
        let timeStamp = Double(NSDate().timeIntervalSince1970)
        let msg = "Hi! I want to be your friend"
        let requestConfirmed = false
        let userTo = getParamsUserTo()
        let userFrom = getParamsUserFrom()
        
        //SaveUID.instance.toUID = toId
        
        DataService.instance.friendRequestIntoDB(fromId, userFrom, toId, userTo, timeStamp, msg, requestConfirmed) { (createRequest, autoKey) in
            if createRequest{
                
                DataService.instance.userFriendRequestIntoDB(autoKey, toId, { (complete) in
                    if complete {
                        DataService.instance.recipientsUserFriendRequestIntoDB(autoKey, toId, recipientAddedIntoDatabase: { (recipientAdded) in
                            if recipientAdded{
                                print("Recipient added in to database")
                            }
                        })
                        
                        let alertController = UIAlertController(title: "Your friend request was successfully sent to the \"\(self.currentUserName!)\"", message: nil, preferredStyle: .alert)
                        let okAlert = UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
                            self.dismiss(animated: true, completion: nil)
                        })
                        alertController.addAction(okAlert)
                        self.present(alertController, animated: true, completion: nil)
                    }
                })
            }
        }
        
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
    
    private func getParamsUserTo() -> Dictionary<String,Any>{
        let user:Dictionary<String,Any> = ["uid": currentUID!, "name": currentUserName!, "image": currentUserUrlImage!, "email": currentUserEmail!, "phone": currentUserPhone!, "online": currentUserStatus!]
        return user
    }
    private func getParamsUserFrom() -> Dictionary<String,Any>{
        let uid = (Auth.auth().currentUser?.uid)!
        let name = User.instance.name
        let image = User.instance.image
        let email = User.instance.email
        let phone = User.instance.phone
        let status = User.instance.online
        let user:Dictionary<String,Any> = ["uid": uid, "name": name, "image": image, "email": email, "phone": phone, "online": status]
        return user
    }
}
