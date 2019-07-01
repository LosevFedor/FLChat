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

    func logInUser(_ email: String, _ password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil{
                print("Unable to autenticate with Firebase using email: \(error!)")
            }else{
                self.userEmail = email
                self.userPassword = password
                self.userPhone = "Add your phone."
                self.userName = "Enter your name."
                print("Sucessfully aytentificate with firebase using email")
            }
        }
    }
    
}
