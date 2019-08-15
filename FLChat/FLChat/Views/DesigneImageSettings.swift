//
//  DesigneImageSettings.swift
//  FLChat
//
//  Created by Softomate on 7/17/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

@IBDesignable
class DesigneImageSettings: UIImageView{
    
    @IBInspectable private var cornerRadiusImage: CGFloat = 1.0{
        didSet{
            layer.cornerRadius = cornerRadiusImage
            layer.masksToBounds = true
        }
    }
    @IBInspectable private var borderWidthImage: CGFloat = 1.0{
        didSet{
            layer.borderWidth = borderWidthImage
        }
    }
    @IBInspectable private var borderColorImage: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColorImage.cgColor
        }
    }
}
