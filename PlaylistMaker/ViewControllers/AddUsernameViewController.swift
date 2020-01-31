//
//  AddUsernameViewController.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/31/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import UIKit

class AddUsernameViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    weak var delegate: UserListViewController?
    
    @IBAction func addButton_touchUpInside(_ sender: Any) {
        if let username =  usernameTextField.text {
            self.dismiss(animated: true) {
                self.delegate?.loadNewUser(withUsername: username)
            }
        }
    }
    
    
}
