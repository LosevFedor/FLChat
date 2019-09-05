//
//  AddNewFriendsVC.swift
//  FLChat
//
//  Created by Fedor Losev on 20/08/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import Firebase

class AddNewFriendsVC: UIViewController{

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchUserByEmail: UITextField!
    
    private var usersArray = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        searchUserByEmail.delegate = self
        searchUserByEmail.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    }
    
    @objc func textFieldDidChanged(){
        
        DataService.instance.getUsersFromDatabase(forSearchQuery: searchUserByEmail.text!) { (returnedUsers) in
            self.usersArray = returnedUsers
            self.collectionView?.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getUsersFromDatabase(forSearchQuery: searchUserByEmail.text!) { (returnedUsers) in
            self.usersArray = returnedUsers
            self.collectionView?.reloadData()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        usersArray.removeAll()
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddNewFriendsVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ADD_NEW_FRIENDS_CELL, for: indexPath) as? AddNewFriendsCell else { return UICollectionViewCell() }
        let user = usersArray[indexPath.row]
        cell.configureCell(user.userName, user.userImage, user.userStatus)
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = usersArray[indexPath.row]
        
        guard let selectNewUserFriendVC = storyboard?.instantiateViewController(withIdentifier: GO_TO_SELECT_NEW_USER_FRIEND) as? SelectNewUserFriendVC else { return }
        
        let user = Users(selectedUser.userId, selectedUser.userName, selectedUser.userImage, selectedUser.userEmail, selectedUser.userPhone, selectedUser.userStatus)
 
        let profileImageUrl = user.userImage
        let url = URL(string: profileImageUrl)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, responce, error) in
            if error != nil {
                print("Cant convert url for image: \(String(describing: error?.localizedDescription))")
            }
            
            DispatchQueue.main.async {
                guard let currentUserImage = UIImage(data: data!) else { return }
                let currentUserId = user.userId
                let currenUserName = user.userName
                let curentUserEmail = user.userEmail
                let curentUserPhone = user.userPhone
                let currentUserStatus = user.userStatus
                let currentUserUrlImage = user.userImage
                selectNewUserFriendVC.initData(currentUserId, currenUserName, currentUserImage, curentUserEmail, curentUserPhone, currentUserStatus, currentUserUrlImage)
                self.present(selectNewUserFriendVC, animated: true, completion: nil)
            }
        }).resume()
    }
    
}

extension AddNewFriendsVC: UITextFieldDelegate{
    
}

