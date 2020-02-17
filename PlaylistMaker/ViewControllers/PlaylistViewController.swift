//
//  PlaylistViewController.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 2/17/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import UIKit

class PlaylistViewController: UIViewController {
    
    var playlist: Playlist?
        
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
    }
}

extension PlaylistViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist?.tracks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let track = playlist?.tracks[indexPath.row] else {
            print("No track found for \(indexPath.row)")
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell") as! PlaylistTrackTableViewCell
        
        cell.trackNameLabel.text = track.trackName
        cell.artistNameLabel.text = track.artistName
        
        return cell
    }
    
    
}
