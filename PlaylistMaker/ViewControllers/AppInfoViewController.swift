//
//  AppInfoViewController.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 2/3/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import UIKit

class AppInfoViewController: UIViewController {

    @IBOutlet weak var versionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadVersioNumber()
    }
    
    func loadVersioNumber() {
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            versionLabel.text = "v\(version)"
        } else {
            versionLabel.text = "version unknown"
        }
    }

}
