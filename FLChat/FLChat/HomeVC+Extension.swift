//
//  HomeVC+Extension.swift
//  FLChat
//
//  Created by Fedor Losev on 09/07/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation
import UIKit

extension HomeVC: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = true
        return transition
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.isPresenting = false
        return transition
    }
}
