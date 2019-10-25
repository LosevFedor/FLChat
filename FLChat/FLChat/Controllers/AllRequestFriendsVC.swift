//
//  AllRequestFriendsVC.swift
//  FLChat
//
//  Created by Fedor Losev on 03/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

class AllRequestFriendsVC: UIViewController {

    @IBOutlet weak var searchUserByEmail: DesigneTextField!
    @IBOutlet weak var collectionView: DesigneCollectionView!
    
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
        print("AllRequestFriendsVC: all referenses was remove")
    }
    
    @objc func textFieldDidChanged(){
        DataService.instance.getUsersWhoSendRequestToFriends(forSearchQuery: searchUserByEmail.text!) { [weak self] (returnUsers) in
            self?.usersArray = returnUsers
            self?.collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        DataService.instance.getUsersWhoSendRequestToFriends(forSearchQuery: searchUserByEmail.text!) { [weak self] (returnUsers) in
            self?.usersArray = returnUsers
            self?.collectionView.reloadData()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        usersArray.removeAll()
        dismiss(animated: true, completion: nil)
    }
    
}

extension AllRequestFriendsVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ALL_REQUEST_FRIEND_CELL, for: indexPath) as? AllRequestFriendsCell else { return UICollectionViewCell() }
        
        let user = usersArray[indexPath.row]
        
        cell.configureCell(user.userName, user.userImage, user.userStatus)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = usersArray[indexPath.row]
        
        guard let selectAllRequestFriendsVC = storyboard?.instantiateViewController(withIdentifier: GO_TO_SELECT_ALL_REQUEST_FRIENDS) as? SelectAllRequestFriendsVC else { return }
        
        let user = Users(selectedUser.userId, selectedUser.userName, selectedUser.userImage, selectedUser.userEmail, selectedUser.userPhone, selectedUser.userStatus)
        
        let profileImageUrl = user.userImage
        let url = URL(string: profileImageUrl)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { [weak self] (data, responce, error) in
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
                
                selectAllRequestFriendsVC.initData(currentUserId,currenUserName, currentUserImage, curentUserEmail, curentUserPhone, currentUserStatus, currentUserUrlImage)
                
                self?.present(selectAllRequestFriendsVC, animated: true, completion: nil)
            }
        }).resume()
    }
}

extension AllRequestFriendsVC: UITextFieldDelegate {
    
}
