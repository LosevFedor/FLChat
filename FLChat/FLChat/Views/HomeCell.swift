//
//  HomeCell.swift
//  FLChat
//
//  Created by Fedor Losev on 06/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

class HomeCell: UICollectionViewCell {
    @IBOutlet weak var userImage: DesigneImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    
    func configureCell(_ userName: String, _ userImage: String, _ userStatus: Bool){
        self.userName.text = userName
        self.userImage.loadImageUsingCacheWithUrlString(userImage)
        self.userStatus.text = "\(userStatus)"
    }
}
