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
    
    @IBOutlet weak var tableView: UITableView!
    
    var playlists = [Playlist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadUserInfo()
        
        tableView.dataSource = self
        
        PlaylistService.instance.createPlaylistForTimeRange(starting: Date().addingTimeInterval(-3_000_000), ending: Date(), name: "Now") { (playlist) in
            self.playlists.append(playlist)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
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

extension UserMenuViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "playlistCell") as? UserMenuPlaylistTableViewCell {
            let playlist = playlists[indexPath.row]
            cell.playlistNameLabel.text = playlist.name
            cell.playlistDescriptionLabel.text = "description"
            return cell
        } else {
            return UITableViewCell()
        }
    }
    
    
}
