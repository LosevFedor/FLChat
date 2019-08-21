//
//  DesigneCollectionView.swift
//  FLChat
//
//  Created by Fedor Losev on 21/08/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class DesigneCollectionView: UICollectionView{
    
    @IBInspectable private var cornerRadiusCollectionView: CGFloat = 1.0 {
        didSet{
            layer.cornerRadius = cornerRadiusCollectionView
        }
    }
    
    @IBInspectable private var borderWidthCollectionView: CGFloat = 1.0{
        didSet{
            layer.borderWidth = borderWidthCollectionView
        }
    }
    
    @IBInspectable private var borderColorCollectionView: UIColor = UIColor.clear{
        didSet{
            layer.borderColor = borderColorCollectionView.cgColor
        }
    }
}
