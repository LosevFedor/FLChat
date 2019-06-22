//
//  ShowHideKeyboard.swift
//  FLChat
//
//  Created by Fedor Losev on 22/06/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation
import UIKit

protocol ShowHideKeyboard {
    func removeObserverKeyboard()
    func addObserverKeyboard()
    func keyboardWillChanged(notification: Notification)
}
    
