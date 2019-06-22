//
//  LablePolicy.swift
//  FLChat
//
//  Created by Softomate on 6/21/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

@IBDesignable
class LablePolicy: UILabel {

    @IBInspectable var labelBorder: CGFloat = 0.2{
        didSet{
            layer.borderWidth = labelBorder
        }
    }
    @IBInspectable var labelBorderColor: UIColor?{
        didSet{
            layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }

}
