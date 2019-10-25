//
//  MyReqyestFriendsVC.swift
//  FLChat
//
//  Created by Fedor Losev on 27/08/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import Firebase

class MyRequestFriendsVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchUserByEmail: UITextField!

    private let requestFriend = RequestFriend()
    private var usersArray = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchUserByEmail.setLeftPaddingPoints(PADDING_POINTS)
        searchUserByEmail.setRightPaddingPoints(PADDING_POINTS)
        
        collectionView.alwaysBounceVertical = true
        collectionView.delegate = self
        collectionView.dataSource = self
        searchUserByEmail.delegate = self
        
        searchUserByEmail.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    }
    
    deinit {
        print("MyRequestFriendsVC: all referenses was remove")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        DataService.instance.getUsersWhomFriendRequestBeenSend(forSearchQuery: searchUserByEmail.text!) { [weak self] (reternUsers) in
            self?.usersArray = reternUsers
            self?.collectionView.reloadData()
        }
    }
    
    @objc func textFieldDidChanged(){
        DataService.instance.getUsersWhomFriendRequestBeenSend(forSearchQuery: searchUserByEmail.text!) { [weak self] (reternedUsers) in
            self?.usersArray = reternedUsers
            self?.collectionView.reloadData()
        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        usersArray.removeAll()
        dismiss(animated: true, completion: nil)
    }
    
}

extension MyRequestFriendsVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MY_REQUEST_FRIENDS_CELL, for: indexPath) as? MyRequestFriendsCell else { return UICollectionViewCell()}
        let user = usersArray[indexPath.row]
        
        cell.configureCell(user.userName, user.userImage, user.userStatus)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = usersArray[indexPath.row]
        
        guard let selectMyRequestFriendsVC = storyboard?.instantiateViewController(withIdentifier: GO_TO_SELECT_MY_REQUEST_FRIENDS) as? SelectMyRequestFriendsVC else { return  }
        
        let user = Users(selectedUser.userName, selectedUser.userImage, selectedUser.userEmail, selectedUser.userPhone, selectedUser.userStatus)
        
        let profileImageUrl = user.userImage
        let url = URL(string: profileImageUrl)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] (data, responce, error) in
            if error != nil {
                print("Cant convert url for image: \(String(describing: error?.localizedDescription))")
            }
            
            DispatchQueue.main.async {
                guard let currentUserImage = UIImage(data: data!) else { return }
                let currenUserName = user.userName
                let curentUserEmail = user.userEmail
                let curentUserPhone = user.userPhone
                let currentUserStatus = user.userStatus
                let currentUserUrlImage = user.userImage
                selectMyRequestFriendsVC.initData(currenUserName, currentUserImage, curentUserEmail, curentUserPhone, currentUserStatus, currentUserUrlImage)
                self?.present(selectMyRequestFriendsVC, animated: true, completion: nil)
            }
        }).resume()
    }
}

extension MyRequestFriendsVC: UITextFieldDelegate {

}
