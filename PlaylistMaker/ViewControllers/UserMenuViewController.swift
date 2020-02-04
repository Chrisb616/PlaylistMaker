//
//  UserMenuViewController.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/31/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import UIKit

class UserMenuViewController: UIViewController {
    
    var user: User?
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var realNameLabel: UILabel!
    @IBOutlet weak var memberSinceLabel: UILabel!
    @IBOutlet weak var totalScrobblesLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserInfo()
    }
    
    func loadUserInfo() {
        
        guard let user = user else {
            usernameLabel.text = ""
            realNameLabel.text = ""
            memberSinceLabel.text = ""
            totalScrobblesLabel.text = ""
            return
        }
        
        usernameLabel.text = user.name.lowercased()
        realNameLabel.text = user.realname.lowercased()
        totalScrobblesLabel.text = "\(user.playcount) scrobbles"
        
        if let registeredDate = user.registered.date {
            memberSinceLabel.text = "member since \(registeredDate.formatted(as: "MMMM yyyy").lowercased())"
        } else {
            memberSinceLabel.text = ""
        }
    }
    
}
