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
        }
    }
    @IBInspectable private var borderWidthImage: CGFloat = 1.0{
        didSet{
            layer.borderWidth = borderWidthImage
        }
    }
    @IBInspectable private var shadowOpacityImage: Float = 1.0{
        didSet{
            layer.shadowOpacity = shadowOpacityImage
        }
    }
    @IBInspectable private var shadowColorImage: UIColor = UIColor.clear{
        didSet{
            layer.shadowColor = shadowColorImage.cgColor
        }
    }
    @IBInspectable private var shadowRadiusImage: CGFloat = 1.0{
        didSet{
            layer.shadowRadius = shadowRadiusImage
        }
    }
    
    
}
