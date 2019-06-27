//
//  LogInUser.swift
//  FLChat
//
//  Created by Softomate on 6/27/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation
import Firebase

class LogInUser{
    
    private (set) public var userEmail:String!
    private (set) public var userPassword:String!
    private (set) public var userPhone:String!
    private (set) public var userName:String!
    
    private init (){}
    
    static var instance = LogInUser()

    func logIn(_ email: String, _ password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil{
                print("Cannot registrate that user: \(error!)")
            }else{
                self.userEmail = email
                self.userPassword = password
                self.userPhone = "Add your phone."
                self.userName = "Enter your name."
                print("boooom!!! Suckes user was registered")
            }
        }
    }
    
}
