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
    @IBOutlet weak var emailSearchTextField: UITextField!
    
    private var usersArray = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        emailSearchTextField.delegate = self
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    }
    
    @objc func textFieldDidChanged(){
        if emailSearchTextField.text == ""{
            DataService.instance.getUsersFromDatabase { (returnedAllUsersArray, error) in
                self.usersArray = returnedAllUsersArray
                self.collectionView?.reloadData()
            }
        }else{
            DataService.instance.getUsersByEmailFromDatabase(forSearchQuery: emailSearchTextField.text!) { (returnedUsersArray) in
                self.usersArray = returnedUsersArray
                self.collectionView?.reloadData()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getUsersFromDatabase { (returnedAllUsersArray, error) in
            self.usersArray = returnedAllUsersArray
            self.collectionView?.reloadData()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
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
        
        guard let selectUserVC = storyboard?.instantiateViewController(withIdentifier: "selectedUserVC") as? SelectUserVC else { return }
        
        let currentUser = Users(selectedUser.userId, selectedUser.userName, selectedUser.userImage, selectedUser.userEmail, selectedUser.userPhone, selectedUser.userStatus)
 
        let profileImageUrl = currentUser.userImage
        let url = URL(string: profileImageUrl)
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, responce, error) in
            if error != nil {
                print("Cant convert url for image: \(String(describing: error?.localizedDescription))")
            }
            
            
            DispatchQueue.main.async {
                guard let currentUserImage = UIImage(data: data!) else { return }
                let currentUserId = currentUser.userId
                let currenUserName = currentUser.userName
                let curentUserEmail = currentUser.userEmail
                let curentUserPhone = currentUser.userPhone
                let currentUserStatus = currentUser.userStatus
                let currentUserUrlImage = currentUser.userImage
                selectUserVC.initData(currentUserId, currenUserName, currentUserImage, curentUserEmail, curentUserPhone, currentUserStatus, currentUserUrlImage)
                self.present(selectUserVC, animated: true, completion: nil)
            }
        }).resume()
    }
    
}

extension AddNewFriendsVC: UITextFieldDelegate{
    
}

