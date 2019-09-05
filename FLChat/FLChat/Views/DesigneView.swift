//
//  DesigneView.swift
//  FLChat
//
//  Created by Fedor Losev on 04/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

@IBDesignable
class DesigneView: UIView {
    @IBInspectable private var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable private var borderWith: CGFloat = 0{
        didSet{
            self.layer.borderWidth = borderWith
        }
    }
    
    @IBInspectable private var shadowOpacity:  Float = 0{
        didSet{
            self.layer.shadowOpacity = shadowOpacity
        }
    }
    
    @IBInspectable private var shadowColor: UIColor = UIColor.clear{
        didSet{
            self.layer.shadowColor = shadowColor.cgColor
        }
    }
    
    @IBInspectable private var shadowRadius: CGFloat = 0{
        didSet{
            self.layer.shadowRadius = shadowRadius
        }
    }
    
    @IBInspectable private var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0){
        didSet{
            self.layer.shadowOffset = shadowOffset
        }
    }
    @IBInspectable private var borderColor: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColor.cgColor
        }
    }
}
