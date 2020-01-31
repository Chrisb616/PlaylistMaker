//
//  UserListViewController.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/31/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    
    var users = [User]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addSegue", let destinationViewController = segue.destination as? AddUsernameViewController {
            destinationViewController.delegate = self
        }
    }
    
}

extension UserListViewController: UITableViewDataSource {
    
    func loadNewUser(withUsername username: String) {
        
        if self.users.contains(where: { $0.name.lowercased() == username.lowercased() }) {
            let alert = UIAlertController(title: nil, message: "\(username.lowercased()) already exists in the user list.", preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: .cancel) { (action) in alert.dismiss(animated: true, completion: nil) }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        UserService.instance.loadInformationFor(username: username) { (user) in
            guard let user = user else { print("Failed to load user") ;return }
            
            self.users.append(user)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "userCell") as? UserListTableViewCell else {
            print("Could not load cell")
            return UITableViewCell()
        }
        
        return cell
    }
    
    
}

