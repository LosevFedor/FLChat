//
//  SelectMyRequestFriendsVC.swift
//  FLChat
//
//  Created by Fedor Losev on 23/08/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import Firebase

class SelectMyRequestFriendsVC: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userEmail: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var userPhone: UILabel!
    
    @IBOutlet weak var backgroundUserImg: UIImageView!
    @IBOutlet weak var userImg: DesigneImage!
    
    private var currentBackgroundUserImg:UIImage!
    private var currentUserName:String!
    private var currentUserImage: UIImage!
    private var currentUserEmail:String!
    private var currentUserPhone:String!
    private var currentUserStatus: Bool!
    private var currentDescriptionText: String!
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
        descriptionText.text = currentDescriptionText
        backgroundUserImg.image = currentBackgroundUserImg
        
        addBlureEffeckForBackgroundUserImg()
    }
    
    func initData(_ name: String, _ image: UIImage, _ email: String, _ phone: String, _ status: Bool, _ urlImage: String){
        currentUserName = name
        currentUserImage = image
        currentBackgroundUserImg = image
        currentUserEmail = email
        currentUserPhone = phone
        currentUserStatus = status
        
        currentUserUrlImage = urlImage
        currentDescriptionText = "This user has not added you as a friend yet."
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
}

