//
//  MessageCell.swift
//  FLChat
//
//  Created by Fedor Losev on 09/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
//import AVFoundation

class MessageCell: UICollectionViewCell {
    
    var MessageVC: MessageVC?
    var message: Message?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activity = UIActivityIndicatorView(style: .whiteLarge)
        activity.translatesAutoresizingMaskIntoConstraints = false
        activity.hidesWhenStopped = true
        return activity
    }()
    
//   lazy var playButton: UIButton = {
//        let button = UIButton(type: .system)
//        button.translatesAutoresizingMaskIntoConstraints = false
//
//        let image = UIImage(named: "playButton")
//        button.setImage(image, for: .normal)
//        button.tintColor  = #colorLiteral(red: 1, green: 0.6632423401, blue: 0, alpha: 1)
//
//        button.addTarget(self, action: #selector(handlePlay), for: .touchUpInside)
//
//        return button
//    }()
    
//    var playerLayer: AVPlayerLayer?
//    var player: AVPlayer?
    
//    @objc func handlePlay(){
//        print("1")
//        if let videoUrlString = message?.video, let url = URL(string: videoUrlString){
//            player = AVPlayer(url: url)
//             print("2")
//            playerLayer = AVPlayerLayer(player: player)
//            playerLayer?.frame = bubbleView.bounds
//            bubbleView.layer.addSublayer(playerLayer!)
//            player?.play()
//            activityIndicatorView.startAnimating()
//            playButton.isHidden = true
//
//        }
//    }
    
//    override func prepareForReuse(){
//        super.prepareForReuse()
//        playerLayer?.removeFromSuperlayer()
//        player?.pause()
//        activityIndicatorView.startAnimating()
//    }
    
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
    
//    lazy var messageVideoView: UIImageView = {
//        let videoImage = UIImageView()
//        videoImage.translatesAutoresizingMaskIntoConstraints = false
//        videoImage.layer.cornerRadius = 16
//        videoImage.layer.masksToBounds = true
//        videoImage.contentMode = .scaleAspectFill
//        videoImage.isUserInteractionEnabled = true
//        videoImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleZoomTap)))
//        return videoImage
//    }()
    
    @objc func handleZoomTap(tapGesture: UITapGestureRecognizer){
//        if message?.video != nil {
//            return
//        }
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
//        bubbleView.addSubview(messageVideoView)
//        bubbleView.addSubview(playButton)
//        bubbleView.addSubview(activityIndicatorView)
        
        setBubbleConstrains()
        setTextViewConstrains()
        setUserImageConstrains()
        
        setMessageImageViewConstrains()
//        setMessageVideoViewConstrains()
//        setPlayButtonViewConstrains()
//        setActivityIndicatorViewConstrains()
        
    }
    
//    private func setActivityIndicatorViewConstrains(){
//        activityIndicatorView.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
//        activityIndicatorView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
//        activityIndicatorView.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        activityIndicatorView.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    }
    
//    private func setPlayButtonViewConstrains(){
//        playButton.centerXAnchor.constraint(equalTo: bubbleView.centerXAnchor).isActive = true
//        playButton.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
//        playButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
//        playButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//    }
    
//    private func setMessageVideoViewConstrains(){
//        messageVideoView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor).isActive = true
//        messageVideoView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
//        messageVideoView.widthAnchor.constraint(equalTo: bubbleView.widthAnchor).isActive = true
//        messageVideoView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
//    }
    
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
