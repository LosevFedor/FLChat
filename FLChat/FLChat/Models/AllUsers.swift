//
//  AllUsers.swift
//  FLChat
//
//  Created by Fedor Losev on 21/08/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation
class AllUsers{
    
    private var _userId: String?
    private var _userName: String?
    private var _userImage: String?
    private var _userEmail: String?
    private var _userPhone: String?
    private var _userStatus: Bool?
    
    var userId: String {
        get{
            return _userId!
        }
    }
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
    var userEmail: String {
        get{
            return _userEmail!
        }
    }
    var userPhone: String {
        get{
            return _userPhone!
        }
    }
    var userStatus: Bool {
        get{
            return _userStatus!
        }
    }
    init(_ id: String, _ name: String, _ image: String, _ email: String, _ phone: String, _ status: Bool) {
        self._userId = id
        self._userName = name
        self._userImage = image
        self._userEmail = email
        self._userPhone = phone
        self._userStatus = status
    }
}
