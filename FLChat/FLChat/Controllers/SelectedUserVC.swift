//
//  SelectedUserVC.swift
//  FLChat
//
//  Created by Fedor Losev on 23/08/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import Firebase

class SelectedUserVC: UIViewController {

    @IBOutlet weak var selectedUserNameLabel: UILabel!
    @IBOutlet weak var selectedUserEmailLabel: UILabel!
    @IBOutlet weak var selectedUserStatusLabel: UILabel!
    @IBOutlet weak var selectedUserWhatYouCanToDoLabel: UILabel!
    @IBOutlet weak var selectedUserPhoneLabel: UILabel!
    
    @IBOutlet weak var selectedBackgroundUserImg: UIImageView!
    @IBOutlet weak var selectedUserImg: DesigneImage!

    @IBOutlet weak var doSomthingButton: UIButton!
    
    var currentBackgroundUserImg:UIImage!
    var currentUserId: String!
    var currentUserName:String!
    var currentUserImage: UIImage!
    var currentUserEmail:String!
    var currentUserPhone:String!
    var currentUserStatus: String!
    var currentUserWhatYouCanToDo: String!
    var currentUserHasTextForButton: String!
    

    fileprivate func addBlureEffeckForselectedBackgroundUserUmg() {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = selectedBackgroundUserImg.bounds
        selectedBackgroundUserImg.addSubview(blurView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedUserNameLabel.text = currentUserName
        selectedUserImg.image = currentUserImage
        selectedUserEmailLabel.text = "Email: \(currentUserEmail!)"
        selectedUserPhoneLabel.text = "Phone: \(currentUserPhone!)"
        selectedUserStatusLabel.text = currentUserStatus
        selectedUserWhatYouCanToDoLabel.text = currentUserWhatYouCanToDo
        selectedBackgroundUserImg.image = currentBackgroundUserImg
        
        addBlureEffeckForselectedBackgroundUserUmg()
    }
    
    func initData(_ id: String, _ name: String, _ image: UIImage, _ email: String, _ phone: String, _ status: Bool){
        currentUserId = id
        currentUserName = name
        currentUserImage = image
        currentBackgroundUserImg = image
        currentUserEmail = email
        currentUserPhone = phone
        currentUserStatus = { () -> String in
            if status{
                return "online"
            }else{
                return "ofline"
            }
        }()
        currentUserWhatYouCanToDo = "You don't have this is person in to your friends"
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendFrienRequestBtnPressed(_ sender: Any){
        
        let toId = currentUserId!
        let fromId = DataService.instance.REF_UID
        let timeStamp = Double(NSDate().timeIntervalSince1970)
        let msgRequestFriend = "Hi! I want to be your friend"
        
        let toUserParams = toUserFriendRequest()
        let fromUserParams = fromUserFriendRequest()
        
        DataService.instance.createRequestAddFriendIntoDB(fromId, toId, timeStamp, msgRequestFriend, fromUserParams, toUserParams)
    }
    
    private func toUserFriendRequest() -> Dictionary<String,Any>{
        let name = currentUserName!
        
        let image = getImageURL(currentUserImage)
        let email = currentUserEmail!
        let status = currentUserStatus!
        
        let userFields: Dictionary<String,Any> = ["toUserName": name, "toUserImage": image, "toUserEmail": email, "toUserStatus":status]
        return userFields
    }
    
    private func fromUserFriendRequest() -> Dictionary<String,Any>{
        let name = User.instance.name
        let image = User.instance.image
        let email = User.instance.email
        let status = User.instance.statusOnline
        
        let whoSendRequest: Dictionary<String,Any> = ["fromUserName": name, "fromUserImage": image, "fromUserEmail": email, "fromUserStatus": status]
        return whoSendRequest
    }
    
    private func getImageURL(_ image: UIImage) -> String{
        let ref = DataService.instance.REF_STORAGE_BASE.child(currentUserId)
        var convertedImageString = ""
        DispatchQueue.main.async {
            ref.downloadURL { (url, error) in
                guard let url = url else { return }
                convertedImageString = url.absoluteString
            }
        }
        
        return convertedImageString
    }

}
