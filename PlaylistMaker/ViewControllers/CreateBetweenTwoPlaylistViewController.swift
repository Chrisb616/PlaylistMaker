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
        
        PlaylistService.instance.createPlaylistForTimeRange(starting: startDate, ending: endDate, username: username, playlistName: playlistName) { (playlist, error) in
            
            
            guard let delegate = self.delegate else {
                print("FAILURE: Delegate has been unloaded")
                return
            }
            
            if let error = error {
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "There was an issue...", message: error.userDisplayString, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                    delegate.present(alert, animated: true, completion: nil)
                }
            }
            
            guard let playlist = playlist else {
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
        
        startDatePicker.maximumDate = Date.fromComponents(year: Date().year, month: 12, day: 31, hour: 0, minute: 0, second: 0)
        endDatePicker.maximumDate = Date.fromComponents(year: Date().year, month: 12, day: 31, hour: 0, minute: 0, second: 0)
    }
    
    func nameForPlaylist(withStartDate startDate: Date, endDate: Date) -> String {
        var name = "from "
        name += startDate.formatted(as: "MM/dd/yy")
        name += " to "
        name += endDate.formatted(as: "MM/dd/yy")
        return name
    }
 }
