//
//  MessageCell.swift
//  FLChat
//
//  Created by Fedor Losev on 09/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell {
    
    var MessageVC: MessageVC?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.text = "userMessageText"
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clear
        tv.textColor = #colorLiteral(red: 0.3798769116, green: 0.4695134759, blue: 0.4463024735, alpha: 1)
        tv.isEditable = false
        return tv
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let userImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "defaultImage")
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    lazy var messageImageView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return image
    }()
    
    lazy var messageVideoView: UIImageView = {
        let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.layer.cornerRadius = 16
        image.layer.masksToBounds = true
        image.contentMode = .scaleAspectFill
        image.isUserInteractionEnabled = true
        image.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
        return image
    }()
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer){
        if let tappedImage = tapGesture.view as? UIImageView {
            self.MessageVC?.performZoomInImageView(tappedImage)
        }
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewRightAnchor: NSLayoutConstraint?
    var bubbleViewLeftAnchor: NSLayoutConstraint?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(userImage)
        
        bubbleView.addSubview(messageImageView)
        bubbleView.addSubview(messageVideoView)
        
        setBubbleConstrains()
        setTextViewConstrains()
        setUserImageConstrains()
        
        setMessageImageViewConstrains()
        setMessageVideoViewConstrains()
        
    }
    
    private func setMessageVideoViewConstrains(){
        messageVideoView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageVideoView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageVideoView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageVideoView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
    }
    
    private func setMessageImageViewConstrains(){
        messageImageView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
        messageImageView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        messageImageView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
        messageImageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
    }
    
    private func setBubbleConstrains(){
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -8)
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraint(equalTo: userImage.rightAnchor, constant: 8)
        
        bubbleView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        bubbleView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    private func setTextViewConstrains(){
        textView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor, constant: 8).isActive = true
        textView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        textView.rightAnchor.constraint(equalTo: bubbleView.rightAnchor).isActive = true
        textView.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
    }
    
    private func setUserImageConstrains(){
        userImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        userImage.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        userImage.widthAnchor.constraint(equalToConstant: 32).isActive = true
        userImage.heightAnchor.constraint(equalToConstant: 32).isActive = true
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
