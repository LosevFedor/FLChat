//
//  HomeVC.swift
//  FLChat
//
//  Created by Softomate on 7/2/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    let transition = SlideInTransiotion()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func settingsBtnPressed(_ sender: Any) {
        guard let settingsVC = storyboard?.instantiateViewController(withIdentifier: GO_TO_SETTINGS) else { return }
        settingsVC.modalPresentationStyle = .overCurrentContext
        settingsVC.transitioningDelegate = self
        present(settingsVC, animated: true, completion: nil)
    }
}
