//
//  UserListTableViewCell.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/31/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import UIKit

class UserListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var realNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        selectedBackgroundView?.isHidden = true
    }
    
    func load(user: User) {
        
        self.usernameLabel.text = user.name.lowercased()
        self.realNameLabel.text = user.realname.lowercased()
        
        let imageUrl = user.image.first { $0.size == "medium" }
        
        if let imageUrl = imageUrl {
            APIClient.instance.getImage(fromUrlString: imageUrl.url) { (image, errorString) in
                if let errorString = errorString { print(errorString) }
               
                DispatchQueue.main.async { self.userImageView.image = image }
           }
        }
    }
}
