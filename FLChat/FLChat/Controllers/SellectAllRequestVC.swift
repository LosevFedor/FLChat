
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
        let fromId = Auth.auth().currentUser?.uid
        let toId = currentUID!
        let time = Double(NSDate().timeIntervalSince1970)
        //let userFrom =
        //let userTo =
        //let ref = DataService.instance.REF_FRIEND.child(<#T##pathString: String##String#>)
        
    }
}
