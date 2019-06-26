//
//  ViewController.swift
//  FLChat
//
//  Created by Softomate on 6/19/19.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate, ShowHideKeyboard {
    
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.delegate = self
        emailField.delegate = self
        
        addObserverKeyboard()
        
    }
    
    deinit {
        removeObserverKeyboard()
    }
    
    @IBAction func LogInButton(_ sender: Any) {
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (result, error) in
            
            if error != nil{
                print("00000")
                self.alertMessage("Warning", "Email or password is not correct. Do you want create new account?")
            }else{
                print("Suckes user sigin")
            }
        }
        
    }
    
    func alertMessage(_ title:String, _ message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: .cancel, handler: { (action) in
            
            //self.logIn()
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func logIn(){
        Auth.auth().createUser(withEmail: emailField.text!, password: passwordField.text!) { (result, error) in
            if error != nil{
                print("Cannot registrate that user")
            }else{
                print("boooom!!! Suckes user was registered")
            }
        }
    }
    
    func removeObserverKeyboard(){
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    func addObserverKeyboard(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChanged(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChanged(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillChanged(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyboardWillChanged(notification: Notification){
        
        guard let keyboardRect = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
            view.frame.origin.y = -keyboardRect.height + 170
        }else{
            view.frame.origin.y = 0
        }
        
    }
    
    func hiddenKeyboard(){
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        hiddenKeyboard()
        return true
    }

}

