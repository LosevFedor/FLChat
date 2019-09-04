//
//  AllRequesFriendsVC.swift
//  FLChat
//
//  Created by Fedor Losev on 03/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

class AllRequesFriendsVC: UIViewController {

    @IBOutlet weak var searchUserByEmail: DesigneTextField!
    @IBOutlet weak var collectionView: DesigneCollectionView!
    
    private var usersArray = [Users]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        searchUserByEmail.delegate = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(animated)
        DataService.instance.getUsersWhoSendRequestToFriends { (returnUsers) in
            self.usersArray = returnUsers
            self.collectionView.reloadData()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        usersArray.removeAll()
        dismiss(animated: true, completion: nil)
    }
    
}

extension AllRequesFriendsVC: UICollectionViewDelegate, UICollectionViewDataSource{
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
}

extension AllRequesFriendsVC: UITextFieldDelegate {
    
}
