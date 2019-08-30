//
//  SelectedUserVC.swift
//  FLChat
//
//  Created by Fedor Losev on 23/08/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import Firebase

class SelectUserVC: UIViewController {

    @IBOutlet weak var selectedUserNameLabel: UILabel!
    @IBOutlet weak var selectedUserEmailLabel: UILabel!
    @IBOutlet weak var selectedUserStatusLabel: UILabel!
    @IBOutlet weak var selectedUserWhatYouCanToDoLabel: UILabel!
    @IBOutlet weak var selectedUserPhoneLabel: UILabel!
    
    @IBOutlet weak var selectedBackgroundUserImg: UIImageView!
    @IBOutlet weak var selectedUserImg: DesigneImage!

    @IBOutlet weak var doSomthingButton: UIButton!
    
    private var currentBackgroundUserImg:UIImage!
    private var currentUserUID: String!
    private var currentUserName:String!
    private var currentUserImage: UIImage!
    private var currentUserEmail:String!
    private var currentUserPhone:String!
    private var currentUserStatus: Bool!
    private var currentUserWhatYouCanToDo: String!
    private var currentUserHasTextForButton: String!
    private var currentUserUrlImage: String!
    
    

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
        
        let status = convertUserStatusToString(currentUserStatus)
      
        selectedUserStatusLabel.text = status
        selectedUserWhatYouCanToDoLabel.text = currentUserWhatYouCanToDo
        selectedBackgroundUserImg.image = currentBackgroundUserImg
        
        addBlureEffeckForselectedBackgroundUserUmg()
    }
    
    func initData(_ id: String, _ name: String, _ image: UIImage, _ email: String, _ phone: String, _ status: Bool, _ urlImage: String){
        currentUserUID = id
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
        let toId = currentUserUID!
        let fromId = (Auth.auth().currentUser?.uid)!
        let timeStamp = Double(NSDate().timeIntervalSince1970)
        let msg = "Hi! I want to be your friend"
        let requestConfirmed = false
        let toIdUser = getToIdUserParams()
        let fromIdUser = getFromIdUserParams()
        
        DataService.instance.createRequestForFriendIntoDB(fromId, fromIdUser, toId, toIdUser, timeStamp, msg, requestConfirmed) { (createRequest, autoKey) in
            if createRequest{
                DataService.instance.createUserRequestForFriendIntoDB(autoKey, requestSend: { (createUserRequrst) in
                    if createUserRequrst{
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
    
    private func getToIdUserParams() -> Dictionary<String,Any>{
        let user:Dictionary<String,Any> = ["name": currentUserName!, "image": currentUserUrlImage!, "email": currentUserEmail!, "phone": currentUserPhone!, "online": currentUserStatus!]
        return user
    }
    private func getFromIdUserParams() -> Dictionary<String,Any>{
        let name = User.instance.name
        let image = User.instance.image
        let email = User.instance.email
        let phone = User.instance.phone
        let status = User.instance.online
        let user:Dictionary<String,Any> = ["name": name, "image": image, "email": email, "phone": phone, "online": status]
        return user
    }
}
