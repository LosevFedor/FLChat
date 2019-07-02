//
//  LogInUser.swift
//  FLChat
//
//  Created by Softomate on 6/27/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation
import Firebase

class AuthService{
    
    private (set) public var userEmail:String!
    private (set) public var userPassword:String!
    private (set) public var userPhone:String!
    private (set) public var userName:String!
    
    static var instance = AuthService()

}
