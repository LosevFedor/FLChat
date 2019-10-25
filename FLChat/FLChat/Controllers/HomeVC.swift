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

    var transition:SlideInTransiotion?
    
    @IBOutlet weak var collectionView: DesigneCollectionView!
    @IBOutlet weak var searchUserByEmail: DesigneTextField!
    
    var usersArray = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        transition = SlideInTransiotion()
        
        searchUserByEmail.setLeftPaddingPoints(PADDING_POINTS)
        searchUserByEmail.setRightPaddingPoints(PADDING_POINTS)
        
        collectionView.alwaysBounceVertical = true
        
        collectionView.delegate = self
        collectionView.dataSource = self
        searchUserByEmail.delegate = self
        
        searchUserByEmail.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
    }
    
    deinit {
        print("HomeView: all referenses was remove")
    }
    
    @objc func textFieldDidChanged() {
        DataService.instance.getAllFrinds(forSearchQuery: searchUserByEmail.text!) { [weak self] (friends) in
            self?.usersArray = friends
            self?.collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchUserByEmail.delegate = self
        DataService.instance.getUserCredentialsFromDatabase() {(completeGetParams) in
            if completeGetParams{
                print("Successfully get params for User from batabase")
            }
        }
        DataService.instance.getAllFrinds(forSearchQuery: searchUserByEmail.text!) { [weak self] (friends) in
            self?.usersArray = friends
            self?.collectionView.reloadData()
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
    
    @IBAction func blacklistBtnPressed(_ sender: Any) {
        print("Blacklist Btn Pressed")
    }
}

extension HomeVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return usersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HOME_CELL, for: indexPath) as? HomeCell else { return UICollectionViewCell() }
        let user = usersArray[indexPath.row]
        cell.configureCell(user.userName, user.userImage, user.userStatus)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = usersArray[indexPath.row]
        
        guard let selectUserMessage = storyboard?.instantiateViewController(withIdentifier: MESSAGE_VC) as? MessageVC else { return }
        
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
                selectUserMessage.initData(currentUserId, currenUserName, currentUserImage, curentUserEmail, curentUserPhone, currentUserStatus, currentUserUrlImage)
                self?.present(selectUserMessage, animated: true, completion: nil)
            }
        }).resume()
    }
    
}

extension HomeVC : UITextFieldDelegate {
    
}
