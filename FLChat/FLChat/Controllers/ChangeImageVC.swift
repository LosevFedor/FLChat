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
        if let image = info[.originalImage] as? UIImage{
            guard let id = Auth.auth().currentUser?.uid else { return }
            let image = DataService.instance.changeUserImage("This is good day today")
            DataService.instance.updateDbImageUser(uid: id, userImage: image)
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
}


