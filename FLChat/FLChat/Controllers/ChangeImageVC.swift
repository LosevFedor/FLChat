//
//  ChangeImageVC.swift
//  FLChat
//
//  Created by Softomate on 7/18/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import AVFoundation
import Firebase

class ChangeImageVC: UIViewController {

    var imagePicker = UIImagePickerController()
    
    @IBOutlet weak var bgView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        setupView()
    }
    
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func setupView(){
        let closeTouch = UITapGestureRecognizer(target: self, action: #selector(ChangeImageVC.closeTap(_:)))
        bgView.addGestureRecognizer(closeTouch)
    }
    
    @objc func closeTap(_ recognizer: UITapGestureRecognizer){
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func makePhotoBtnPressed(_ sender: Any) {
      
    }
    @IBAction func selectUserImageBtnPressed(_ sender: UIButton) {
        imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = true
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension ChangeImageVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker:UIImage?
        
        if let editedImage = info[.editedImage] as? UIImage{
//            guard let id = Auth.auth().currentUser?.uid else { return }
//            let editImage = DataService.instance.changeUserImage("editedImage")
//            DataService.instance.updateDbImageUser(uid: id, userImage: editImage)
            
            selectedImageFromPicker = editedImage
        }else if let originalImage = info[.originalImage] as? UIImage{
//            guard let id = Auth.auth().currentUser?.uid else { return }
//            let originImage = DataService.instance.changeUserImage("This is good day today")
//            DataService.instance.updateDbImageUser(uid: id, userImage: originImage)
            selectedImageFromPicker = originalImage
        }
        
        if let selectedImage = selectedImageFromPicker{
            uploadToFirebaseStorageUsingImage(selectedImage)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    private func uploadToFirebaseStorageUsingImage(_ image: UIImage){
        let uid = DataService.instance.REF_UID
        let ref = DataService.instance.REF_STORAGE_BASE.child(uid)
        
        if let uploadData = image.jpegData(compressionQuality: 0.2){
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                if error != nil{
                    print("Failed to upload image:\(error)")
                }
 
                print(metadata?.accessibilityPath as Any)
            }
        }
    }
    
}


