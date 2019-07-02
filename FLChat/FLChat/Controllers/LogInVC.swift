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
    
    @IBAction func facebookPressed(_ sender: Any) {
    }
    
    @IBAction func googlePressed(_ sender: Any) {
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        if let email = emailField.text, let password = passwordField.text{
            Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                if error != nil{
                    guard let err = error, err.localizedDescription == "There is no user record corresponding to this identifier. The user may have been deleted." else {
                        self.standartErrors(WAR, (error?.localizedDescription)! as String)
                        return
                    }
                    let descriptionText = "\(err.localizedDescription) Do you want to create a new account?"
                    self.customErrors(WAR, descriptionText)
                }else{
                    self.performSegue(withIdentifier: "goToHome", sender: nil)
                }
            }
        }
    }
    
    func logInUser(_ email: String, _ password: String){
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if error != nil{
                self.standartErrors(WAR, error!.localizedDescription)
            }else{
                self.performSegue(withIdentifier: "goToHome", sender: nil)
            }
        }
    }

    
    func standartErrors(_ title:String, _ message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func customErrors(_ title:String, _ message: String){
        let alert = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "Yes", style: .cancel, handler: { (action) in

            guard let password = self.passwordField.text, self.passwordField.text!.count >= 6 else {
                self.standartErrors(WAR, PASSWORD_LESS)
                return
            }
            guard let email = self.emailField.text, self.emailField.text!.count >= 6 else {
                self.standartErrors(WAR, EMAIL_LESS)
                return
            }
           self.logInUser(email, password)
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

