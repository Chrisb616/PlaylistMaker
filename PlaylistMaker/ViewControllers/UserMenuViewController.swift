//
//  UserMenuViewController.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/31/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import UIKit

class UserMenuViewController: UIViewController {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var memberSinceLabel: UILabel!
    
    var username: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let username = username else {
            self.dismiss(animated: true, completion: nil)
            return
        }
        
        UserService.instance.loadInformationFor(username: username) { (user) in
            guard let user = user else { return }
            
            self.loadView(forUser: user)
        }
        
    }
    
    private func loadView(forUser user: User) {
        let imageURL = user.image.first { $0.size == "medium"}?.url ?? ""
        
        APIClient.instance.getImage(fromUrlString: imageURL) { (image, errorString) in
            DispatchQueue.main.async {
                self.usernameLabel.text = user.name.lowercased()
                self.memberSinceLabel.text = "member since \(user.registered.date?.formatted(as: "MMMM, yyyy").lowercased() ?? "[unknown]")"
                self.userImageView.image = image
                
                self.usernameLabel.isHidden = false
                self.memberSinceLabel.isHidden = false
                self.userImageView.isHidden = false
            }
        }
    }
    
    
}
