//
//  LogInUser.swift
//  FLChat
//
//  Created by Softomate on 6/27/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation

class LogInUser{
    
    private (set) public var userEmail:String
    private (set) public var userPassword:String
    private (set) public var userPhone:String
    private (set) public var userName:String
    
    init(email: String, password: String, phone:String, name:String){
        userEmail = email
        userPassword = password
        userPhone = phone
        userName = name
    }
    
    
}
