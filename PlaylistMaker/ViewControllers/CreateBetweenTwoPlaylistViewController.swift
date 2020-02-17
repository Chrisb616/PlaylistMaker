//
//  CreateBetweenTwoPlaylistViewController.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 2/13/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import UIKit

class CreateBetweenTwoPlaylistViewController: UIViewController {
    
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    weak var delegate: UserMenuViewController?
    
    @IBAction func makePlaylistButton_TouchUpInside(_ sender: Any) {
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        
        let playlistName = nameForPlaylist(withStartDate: startDate, endDate: endDate)
        guard let username = delegate?.user?.name else {
            print("User not found.")
            return
        }
        
        self.dismiss(animated: true, completion: nil)
        
        PlaylistService.instance.createPlaylistForTimeRange(starting: startDate, ending: endDate, username: username, playlistName: playlistName) { (playlist) in
            
            guard let delegate = self.delegate else {
                print("FAILURE: Delegate has been unloaded")
                return
            }
            
            DispatchQueue.main.async {
                delegate.playlists.append(playlist)
                delegate.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        startDatePicker.minimumDate = Date.fromComponents(year: 2002, month: 3, day: 20, hour: 0, minute: 0, second: 0)
        endDatePicker.minimumDate = Date.fromComponents(year: 2002, month: 3, day: 20, hour: 0, minute: 0, second: 0)
        
        startDatePicker.maximumDate = Date()
        endDatePicker.maximumDate = Date()
    }
    
    func nameForPlaylist(withStartDate startDate: Date, endDate: Date) -> String {
        var name = "from "
        name += startDate.formatted(as: "MM/dd/yy")
        name += " to "
        name += endDate.formatted(as: "MM/dd/yy")
        return name
    }
 }
