//
//  AllUsers.swift
//  FLChat
//
//  Created by Fedor Losev on 21/08/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation
class AllUsers{
    
    private var _userName: String?
    private var _userImage: String?
    private var _userStatus: Bool?
    
    var userName: String {
        get{
            return _userName!
        }
    }
    var userImage: String {
        get{
            return _userImage!
        }
    }
    var userStatus: Bool {
        get{
            return _userStatus!
        }
    }
    
    init(_ name: String, _ image: String, _ status: Bool) {
        self._userName = name
        self._userImage = image
        self._userStatus = status
    }
}
