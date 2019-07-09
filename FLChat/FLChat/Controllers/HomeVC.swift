//
//  HomeVC.swift
//  FLChat
//
//  Created by Softomate on 7/2/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        performSegue(withIdentifier: GO_TO_SETTINGS, sender: self)
    }
    
}
