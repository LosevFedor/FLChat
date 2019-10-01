//
//  Message.swift
//  FLChat
//
//  Created by Fedor Losev on 10/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//
import UIKit
import Firebase

class Message: NSObject {
    var id: String?
    
    var fromId: String?
    var toId: String?
    var timeStamp: Double?
    var message: String?
    
    var image: String?
    
    var imageWidth: NSNumber?
    var imageHeight: NSNumber?
}
