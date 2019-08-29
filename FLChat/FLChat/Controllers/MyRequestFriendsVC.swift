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
    @IBOutlet weak var emailSearchTextField: UITextField!

    
    private let requestToFriend = RequestFriend()
    private var usersArrayFriendRequest = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        emailSearchTextField.delegate = self
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getUsersWhomFriendRequestBeenSendFromDB { (reternUsers) in
            self.usersArrayFriendRequest = reternUsers
            self.collectionView.reloadData()
        }
    }
    
    func observRequestToFriend(completeObserv: @escaping(_ complete: Bool)->()){
        
    }
    @objc func textFieldDidChanged(){
        if emailSearchTextField.text == ""{

        }else{

        }
    }

    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension MyRequestFriendsVC: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
        return usersArrayFriendRequest.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MY_REQUEST_FRIENDS_CELL, for: indexPath) as? MyRequestFriendsCell else { return UICollectionViewCell()}
        let user = usersArrayFriendRequest[indexPath.row]
        cell.configureCell(user.userName, user.userImage, user.userStatus)
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension MyRequestFriendsVC: UITextFieldDelegate {

}
