//
//  MessageCell.swift
//  FLChat
//
//  Created by Fedor Losev on 09/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "userMessageText"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = #colorLiteral(red: 0.3798769116, green: 0.4695134759, blue: 0.4463024735, alpha: 1)
        return tv
    }()
    
    var bubleWidthAnchor: NSLayoutConstraint?
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.6287381053, green: 0.938175261, blue: 0.8685600162, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(bubbleView)
        bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8).isActive = true
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        
        bubleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubleWidthAnchor?.isActive = true
        
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
        
        addSubview(textView)
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    func configureCell(_ fromId: String, _ toId: String, _ timeStamp: Double, _ image: String, _ message: String){
        let _ = setTimeStamp(timeStamp)
    }
    
    func setTimeStamp(_ time:Double) -> String {
        let timestampDate = NSDate(timeIntervalSince1970: time)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:ss a"
        return dateFormatter.string(from: timestampDate as Date)
    }

}
