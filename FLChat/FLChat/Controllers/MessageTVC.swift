//
//  MessageTVC.swift
//  FLChat
//
//  Created by Fedor Losev on 09/09/2019.
//  Copyright © 2019 losev.feder2711@gmail.com. All rights reserved.
//

import UIKit

class MessageVC: UIViewController {

    var _name: String!
    var _image: UIImage!
    var _status: Bool!
    
    var _email: String?
    var _phone: String?
    var _urlImage: String?
    var _uid: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view?.backgroundColor = UIColor.white
        setupInputComponents()
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
    
    func setupInputComponents(){
        let containerView = UIView()
        containerView.backgroundColor = UIColor.red
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        //containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -200)
        containerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        containerView.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    @IBAction func backBtnPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


