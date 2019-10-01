//
//  MessageVC.swift
//  FLChat
//
//  Created by Fedor Losev on 10/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import Firebase

class MessageVC: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImage: DesigneImage!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userStatus: UILabel!
    
    @IBOutlet weak var userTextMessage: DesigneTextField!
    @IBOutlet weak var sendBtn: UIButton!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var messagesArray = [Message]()
    
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
        
        setUserFields()
        
        collectionView.keyboardDismissMode = UIScrollView.KeyboardDismissMode.onDrag
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hiddenKeyboard()
        return true
    }
    
    func hiddenKeyboard(){
        userTextMessage.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        observUserMessages { (returnedMessageArray) in
            self.messagesArray = returnedMessageArray
        }
        
        
        self.sendBtn.isEnabled = false
        userTextMessage.addTarget(self, action: #selector(textFieldDidChanged), for: .editingChanged)
        
        setupKeyboardObservers()
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
    
    private func setUserFields(){
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
        handleSend(nil, nil)
        clearTextField()
        sendBtn.isEnabled = false
    }
    
    
    @IBAction func sendPictureBtnPressed(_ sender: Any) {
        let imagepickerController = UIImagePickerController()
        
        imagepickerController.delegate = self
        imagepickerController.allowsEditing = true
        present(imagepickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker:UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[.originalImage] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
           uploadToStorageUsingImage(selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func uploadToStorageUsingImage(_ image: UIImage){
        
        let uid = (Auth.auth().currentUser?.uid)!
        let ref = DataService.instance.REF_STORAGE_USER_PICTURES.child(uid)
        
        if let uploadData = image.jpegData(compressionQuality: COMPRESSION_IMAGE){
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil{
                    print("Failed to upload image:\(String(describing: error?.localizedDescription))")
                }
                ref.downloadURL { (url, error) in
                    guard let url = url else{ return }
                    self.handleSend(url.absoluteString, image)
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSend(_ imageUrl: String?, _ img: UIImage?){
        let ref = DataService.instance.REF_MESSAGE
        let childRef = ref.childByAutoId()
        
        let fromId = (Auth.auth().currentUser?.uid)!
        let toId = _uid!
        let timeStamp = Double(NSDate().timeIntervalSince1970)
        let message = userTextMessage.text!
        
        var value: Dictionary<String,Any> = [:]
        
        if let image = imageUrl {
            value = ["fromId": fromId, "toId": toId, "timeStamp": timeStamp, "imageUrl": image, "imageWidth": (img?.size.width)!, "imageHeight": (img?.size.height)!  ] as [String : Any]
        }else{
            value = ["fromId": fromId, "toId": toId, "timeStamp": timeStamp, "message": message] as [String : Any]
        }
        
        childRef.updateChildValues(value) { (error, ref) in
            if error != nil{
                print("Can't update messade in to batabase: \(String(describing: error?.localizedDescription))")
                return
            }
            
            let userMessagesRef = DataService.instance.REF_USER_MESSAGE.child(fromId).child(toId)
            guard let messageId = childRef.key else { return }
            userMessagesRef.updateChildValues([messageId: 1])
        
            let recipientUserMessagesRef = DataService.instance.REF_USER_MESSAGE.child(toId).child(fromId)
            recipientUserMessagesRef.updateChildValues([messageId:1])
            
        }
    }
    
    func observUserMessages(complete: @escaping(_ arrayMessage: [Message]) -> ()){
        guard let uid = Auth.auth().currentUser?.uid, let toId = _uid else { return }
        
        var messages = [Message]()
        
        let ref = DataService.instance.REF_USER_MESSAGE.child(uid).child(toId)
        ref.observe(.childAdded, with: { (snapshot) in
            let messageId = snapshot.key
            let messageReference = DataService.instance.REF_MESSAGE.child(messageId)
            
            messageReference.observeSingleEvent(of: .value, with: { (snapshot) in
                guard let dict = snapshot.value as? Dictionary<String,Any> else { return }
                let message = Message()
                message.fromId = (dict["fromId"] as? String)!
                message.toId = (dict["toId"] as? String)!
                
                if let text = dict["message"] as? String{
                    message.message = text
                }
                
                if let image = dict["imageUrl"] as? String {
                    message.image = image
                    message.imageWidth = dict["imageWidth"] as? NSNumber
                    message.imageHeight = dict["imageHeight"] as? NSNumber
                }
                
                message.timeStamp = (dict["timeStamp"] as? Double)!
                if toId == self._uid!{
                    messages.append(message)
                    complete(messages)
                    
                    self.attemptReloadOfCollection()
                    
                }
            }, withCancel: nil)
        }, withCancel: nil)
    }
    
    var timer: Timer?
    private func attemptReloadOfCollection(){
        self.timer?.invalidate()
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.handleReloadCollection), userInfo: nil, repeats: false)
    }
    
    @objc func handleReloadCollection(){
        DispatchQueue.main.async {
            self.collectionView.reloadData()
            self.scrollMessage()
        }
    }
    
    private func scrollMessage(){
        let indexPath = NSIndexPath(item: self.messagesArray.count - 1, section: 0)
        self.collectionView.scrollToItem(at: indexPath as IndexPath, at: .bottom, animated: true)
    }
    
    private func clearTextField(){
        userTextMessage.text = nil
    }

}

extension MessageVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MESSAGE_CELL, for: indexPath) as? MessageCell else { return UICollectionViewCell()}
        
        let message = messagesArray[indexPath.row]
       
        
        setupCell(cell, message)
        cell.textView.text = message.message
        
        if let text = message.message{
             let addTextSizeWight: CGFloat = 32
            cell.bubbleWidthAnchor?.constant = estimateFromeForText(text).width + addTextSizeWight
        }else if message.image != nil {
            let addImageSizeWight: CGFloat = 200
            cell.bubbleWidthAnchor?.constant = addImageSizeWight
        }
        
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
        
        if let messageImageUrl = message.image {
            cell.messageImageView.loadImageUsingCacheWithUrlString(messageImageUrl)
            cell.messageImageView.isHidden = false
            cell.bubbleView.backgroundColor = .clear
        }else{
            cell.messageImageView.isHidden = true
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var height: CGFloat = 80
        
        let message = messagesArray[indexPath.item]
        if let text = message.message{
            let addTextSizeWight: CGFloat = 32
            height = estimateFromeForText(text).height + addTextSizeWight
        }else if let imageWidth = message.imageWidth?.floatValue, let imageHeight = message.imageHeight?.floatValue{
            
            height = CGFloat(imageHeight/imageWidth * 200)
        }
        let width = UIScreen.main.bounds.width
        return CGSize(width: width, height: height)
    }
    
    private func estimateFromeForText(_ text: String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)], context: nil)
    }
}

extension MessageVC: UITextFieldDelegate {
    
}



