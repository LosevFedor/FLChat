//
//  AddNewFriendsCell.swift
//  FLChat
//
//  Created by Fedor Losev on 20/08/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

class AddNewFriendsCell: UICollectionViewCell {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var userStatus: UILabel!
    
    
    func configureCell(userName: String, userImage: String, userStatus: Bool){
        self.userName.text = userName
        let profileImageUrl = userImage
        let url = URL(string: profileImageUrl)
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, responce, error) in
            if error != nil {
                print("Cant convert the url for image: \(String(describing: error?.localizedDescription))")
            }
            DispatchQueue.main.async {
                self.userImage.image = UIImage(data: data!)
            }
        }).resume()
        self.userStatus.text = "\(userStatus)"
    }
}
