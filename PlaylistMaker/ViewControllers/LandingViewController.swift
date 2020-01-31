//
//  LandingViewController.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/31/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import UIKit

class LandingViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    public override func viewDidLoad() {
        
    }
    
    @IBAction func GoButton_TouchUpInside(_ sender: Any) {
        if let usernameString = usernameTextField.text {
            APIClient.instance.getInfoFor(username: usernameString) { (response, errorString) in
                if let errorString = errorString {
                    print(errorString)
                }
                
                guard let response = response else {
                    print("No Response")
                    return
                }
                
                print(response.user.realname)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if (segue.identifier == "userMenu") {
            guard
                let viewController = segue.destination as? UserMenuViewController,
                let usernameString = usernameTextField.text
                else {
                    return
            }
            
            viewController.username = usernameString
        }
    }
}
