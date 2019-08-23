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
    
    var allUsersArray = [AllUsers]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.delegate = self
        collectionView?.dataSource = self
        emailSearchTextField.delegate = self
        emailSearchTextField.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        
    }
    
    @objc func textFieldDidChanged(){
        if emailSearchTextField.text == ""{
            DataService.instance.getAllUsersFromDatabase { (returnedAllUsersArray, error) in
                self.allUsersArray = returnedAllUsersArray
                self.collectionView?.reloadData()
            }
        }else{
            DataService.instance.getUserByEmailFromDatabase(forSearchQuery: emailSearchTextField.text!) { (returnedUsersArray) in
                self.allUsersArray = returnedUsersArray
                self.collectionView?.reloadData()
            }
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DataService.instance.getAllUsersFromDatabase { (returnedAllUsersArray, error) in
            self.allUsersArray = returnedAllUsersArray
            self.collectionView?.reloadData()
        }
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension AddNewFriendsVC: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return allUsersArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ADD_NEW_FRIENDS_CELL, for: indexPath) as? AddNewFriendsCell else {
            return UICollectionViewCell()
        }
        let allUsers = allUsersArray[indexPath.row]
        cell.configureCell(allUsers.userName, allUsers.userImage, allUsers.userStatus)
        
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
}

extension AddNewFriendsVC: UITextFieldDelegate{
    
}

