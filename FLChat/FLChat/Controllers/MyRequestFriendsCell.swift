//
//  MyRequestFriendsCell.swift
//  FLChat
//
//  Created by Fedor Losev on 27/08/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

class MyRequestFriendsCell: UICollectionViewCell {
    
    @IBOutlet weak var userImage: DesigneImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    
    func configureCell(_ userName: String, _ userImage: String, _ userStatus: Bool){
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
