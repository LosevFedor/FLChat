//
//  FacebookGoogleButton.swift
//  FLChat
//
//  Created by Softomate on 6/21/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

@IBDesignable
class FacebookGoogleButton: UIButton {

    @IBInspectable var borderWidth: CGFloat = 1.0{
        didSet{
            layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderTextColor:UIColor?{
        didSet{
            layer.borderColor = borderTextColor?.cgColor
        }
    }
    
//    override func prepareForInterfaceBuilder(){
//        castomizeButtons()
//    }
//    override func awakeFromNib() {
//        super.awakeFromNib()
//        castomizeButtons()
//    }
//    
//    func castomizeButtons(){
//       // layer.backgroundColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//        layer.borderWidth = 0.2
//        layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//    }
}
