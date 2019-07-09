//
//  UserDefaultExtentions.swift
//  FLChat
//
//  Created by Fedor Losev on 09/07/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation

extension UserDefaults {
    
    enum UserDefaultKeys: String{
        case isLoggedIn
    }
    
    func setIsLoggedIn(value: Bool){
        set(value, forKey: UserDefaultKeys.isLoggedIn.rawValue)
        synchronize()
    }
    
    func isLoggedIn() -> Bool{
        return bool(forKey: UserDefaultKeys.isLoggedIn.rawValue)
    }
    
    func removeLogIn(){
        removeObject(forKey: UserDefaultKeys.isLoggedIn.rawValue)
        synchronize()
    }
}
