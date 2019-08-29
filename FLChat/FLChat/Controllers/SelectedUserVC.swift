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
    var currentUserUID: String!
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
        currentUserUID = id
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
        let toId = currentUserUID!
        let fromId = DataService.instance.REF_UID
        let timeStamp = Double(NSDate().timeIntervalSince1970)
        let msgRequestFriend = "Hi! I want to be your friend"
        let friendRequestConfirmed = false
        DataService.instance.createRequestForFriendIntoDB(fromId, toId, timeStamp, msgRequestFriend, friendRequestConfirmed) { (sendRequest) in
            
            let alertController = UIAlertController(title: "Your friend request was successfully sent to the \"\(self.currentUserName!)\"", message: nil, preferredStyle: .alert)
            let okAlert = UIAlertAction(title: "Ok", style: .default, handler: { (okAction) in
                self.dismiss(animated: true, completion: nil)
            })
            alertController.addAction(okAlert)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
