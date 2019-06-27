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
    
    static let instance = LoginVC()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        passwordField.delegate = self
        emailField.delegate = self
        
        addObserverKeyboard()
        
    }
    
    deinit {
        removeObserverKeyboard()
    }
    
    @IBAction func LoginPressed(_ sender: Any) {
        
        Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!) { (result, error) in
            if error != nil{
                if self.emailField.text! == "" || self.passwordField.text == ""{
                    self.fieldsNotFilled(WAR, FIELDS_NOT_FILLED)
                }else{
                    self.emailOrPasswordIncorrect(WAR, EMAIL_PASSWORD_INCORRECT)
                }
            }else{
                
                // i need save ore get all credentials from server
                print("Suckes user sigin")
            }
        }
        
    }
    
    func fieldsNotFilled(_ title:String, _ message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func emailOrPasswordIncorrect(_ title:String, _ message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: .cancel, handler: { (action) in
            
            AuthService.instance.logInUser(self.emailField.text!, self.passwordField.text!)
            alert.dismiss(animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction.init(title: "Try again", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)
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

