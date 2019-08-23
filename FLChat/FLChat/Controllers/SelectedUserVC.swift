//
//  SelectedUserVC.swift
//  FLChat
//
//  Created by Fedor Losev on 23/08/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

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
        selectedUserEmailLabel.text = currentUserEmail
        selectedUserPhoneLabel.text = currentUserPhone
        selectedUserStatusLabel.text = currentUserStatus
        selectedUserWhatYouCanToDoLabel.text = currentUserWhatYouCanToDo
        selectedBackgroundUserImg.image = currentBackgroundUserImg
        
        addBlureEffeckForselectedBackgroundUserUmg()
    }
    
    func initData(_ name: String, _ image: UIImage, _ email: String, _ phone: String, _ status: Bool){
        currentUserName = name
        currentUserImage = image
        currentBackgroundUserImg = image
        currentUserEmail = "Email: \(email)"
        currentUserPhone = "Phone: \(phone)"
        currentUserStatus = { () -> String in
            if status{
                return "online"
            }else{
                return "ofline"
            }
        }()
        currentUserWhatYouCanToDo = "You can sand message this is user"
    }
    
    @IBAction func BackBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func doSomthingButton(_ sender: Any){
        
    }
    

}
