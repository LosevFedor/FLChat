//
//  HomeVC.swift
//  FLChat
//
//  Created by Softomate on 7/2/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import Firebase

class HomeVC: UIViewController {

    let transition = SlideInTransiotion()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let uid = (Auth.auth().currentUser?.uid)!
        DataService.instance.getUserCredentialsFromDatabase(uid: uid) { (completeGetParams) in
            if completeGetParams{
                print("Successfully get params for User from batabase")
            }
        }
    }
    
    @IBAction func addNewFriendsBtnPressed(_ sender: Any) {
        guard let addNewFriendsVC = storyboard?.instantiateViewController(withIdentifier: GO_TO_ADD_NEW_FRIENDS) else { return }
        present(addNewFriendsVC, animated: true, completion: nil)
    }
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        guard let settingsVC = storyboard?.instantiateViewController(withIdentifier: GO_TO_SETTINGS) else { return }
        settingsVC.modalPresentationStyle = .overCurrentContext
        settingsVC.transitioningDelegate = self
        present(settingsVC, animated: true, completion: nil)
    }
    
    @IBAction func myRequestFriendBtnPressed(_ sender: Any) {
        guard let myRequesrFriend = storyboard?.instantiateViewController(withIdentifier: GO_TO_MY_REQUEST_FRIEND) else { return }
        present(myRequesrFriend, animated: true, completion: nil)
    }
    
    @IBAction func allRequestFriendBtnPressed(_ sender: Any) {
        guard let allRequestFriend = storyboard?.instantiateViewController(withIdentifier: GO_TO_ALL_REQUEST_FRIEND) else { return }
        present(allRequestFriend, animated: true, completion: nil)
    }
}
