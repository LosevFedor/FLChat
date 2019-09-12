//
//  MessageVC.swift
//  FLChat
//
//  Created by Fedor Losev on 10/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import Firebase

class MessageVC: UIViewController {

    @IBOutlet weak var userImage: DesigneImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    
    @IBOutlet weak var userTextMessage: DesigneTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var messagesArray = [Message]()
    var messages = [Message]()
    
    var _name: String!
    var _image: UIImage!
    var _status: Bool!
    
    var _email: String?
    var _phone: String?
    var _urlImage: String?
    var _uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.alwaysBounceVertical = true
        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 10, right: 0)
        collectionView.backgroundColor = #colorLiteral(red: 0.8511615396, green: 0.9766409993, blue: 0.9483792186, alpha: 1)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        userTextMessage.delegate = self
        
        self.sendBtn.isEnabled = false
        
        setupUserFields()
        userTextMessage.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        self.sendBtn.isEnabled = false
        
        collectionView?.keyboardDismissMode = .interactive
        setupKeyboardObservers()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardObservers(){
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    @objc func handleKeyboardWillShow(_ notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        guard let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double  else { return }
        
        view.frame.origin.y = -keyboardRect.height
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    @objc func handleKeyboardWillHide(_ notification: Notification){
        guard let keyboardDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double  else { return }
        
        view.frame.origin.y = 0
        UIView.animate(withDuration: keyboardDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    func hiddenKeyboard(){
        userTextMessage.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hiddenKeyboard()
        return true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observUserMessages { (returnedMessageArray) in
            self.messagesArray = returnedMessageArray
        }
        
    }
    
    @objc func textFieldDidChanged(){
        if userTextMessage.text != ""{
            self.sendBtn.isEnabled = true
        }else{
            self.sendBtn.isEnabled = false
        }
    }
    
    func initData(_ id: String, _ name: String, _ image: UIImage, _ email: String, _ phone: String, _ status: Bool, _ urlImage: String){
        _uid = id
        _name = name
        _image = image
        _email = email
        _phone = phone
        _status = status
        _urlImage = urlImage
    }
    
    private func setupUserFields(){
        self.userImage.image = _image
        self.userName.text = _name
        self.userStatus.text = convertUserStatus(_status)
    }
    
    private func convertUserStatus(_ status: Bool) -> String {
        let isOnline: String!
        if status {
            isOnline = "online"
            userStatus.textColor = #colorLiteral(red: 0.3744381421, green: 1, blue: 0.2836122325, alpha: 1)
        }else{
            isOnline = "ofline"
            userStatus.textColor = #colorLiteral(red: 0.9411764741, green: 0.4980392158, blue: 0.3529411852, alpha: 1)
        }
        return isOnline
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func sendBtnPressed(_ sender: Any) {
        handleSend()
        clearTextField()
    }
    
    func handleSend(){
        let ref = DataService.instance.REF_MESSAGE
        let childRef = ref.childByAutoId()
        
        let fromId = (Auth.auth().currentUser?.uid)!
        let toId = _uid!
        let timeStamp = Double(NSDate().timeIntervalSince1970)
        let message = userTextMessage.text!
        
        let value = ["fromId": fromId, "toId": toId, "timeStamp": timeStamp, "message": message] as [String : Any]
        
        childRef.updateChildValues(value) { (error, ref) in
            if error != nil{
                print("Can't update messade in to batabase: \(String(describing: error?.localizedDescription))")
                return
            }
            
            let userMessagesRef = DataService.instance.REF_USER_MESSAGE.child(fromId)
            guard let messageId = childRef.key else { return }
            userMessagesRef.updateChildValues([messageId: 1])
        
            let recipientUserMessagesRef = DataService.instance.REF_USER_MESSAGE.child(toId)
            recipientUserMessagesRef.updateChildValues([messageId:1])
        }
    }
    
    func observUserMessages(complete: @escaping(_ arrayMessage: [Message]) -> ()){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let ref = DataService.instance.REF_USER_MESSAGE.child(uid)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageReference = DataService.instance.REF_MESSAGE.child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dict = snapshot.value as? Dictionary<String,Any> else { return }
                let message = Message()
                message.fromId = (dict["fromId"] as? String)!
                message.toId = (dict["toId"] as? String)!
                message.message = (dict["message"] as? String)!
                message.timeStamp = (dict["timeStamp"] as? Double)!
                if message.chatPartnerId() == self._uid!{
                    self.messages.append(message)
                    complete(self.messages)
                    
                    self.timer?.invalidate()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadCollection), userInfo: nil, repeats: false)
                    
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    var timer: Timer?
    
    @objc func handleReloadCollection(){
        DispatchQueue.main.async {
            print("we reloaded Message")
            self.collectionView.reloadData()
        }
    }
    func clearTextField(){
        userTextMessage.text = ""
    }

}

extension MessageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MESSAGE_CELL, for: indexPath) as? MessageCell else { return UICollectionViewCell()}
        
        let message = messagesArray[indexPath.row]
        let moreSizeWight: CGFloat = 32
        
       setupCell(cell, message)
        
        cell.textView.text = message.message
        cell.bubbleWidthAnchor?.constant = estimateFromeForText(message.message).width + moreSizeWight
        return cell
    }
    private func setupCell(_ cell: MessageCell, _ message: Message){
        
        guard let profileUserUrl = _urlImage else {return}
        cell.userImage.loadImageUsingCacheWithUrlString(profileUserUrl)
        if message.fromId == Auth.auth().currentUser?.uid{
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0.6287381053, green: 0.938175261, blue: 0.8685600162, alpha: 1)
            cell.userImage.isHidden = true
            cell.bubbleViewRightAnchor?.isActive = true
            cell.bubbleViewLeftAnchor?.isActive = false
        }else{
            cell.bubbleView.backgroundColor = #colorLiteral(red: 0.829066813, green: 0.8015608191, blue: 0.9317680597, alpha: 1)
            cell.userImage.isHidden = false
            cell.bubbleViewRightAnchor?.isActive = false
            cell.bubbleViewLeftAnchor?.isActive = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 60
        if let text = messages[indexPath.item].message{
            let moreSizeHeight: CGFloat = 30
            height = estimateFromeForText(text).height + moreSizeHeight
        }
        return CGSize(width: view.frame.width, height: height)
    }
    
    private func estimateFromeForText(_ text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}

extension MessageVC: UITextFieldDelegate {
    
}



