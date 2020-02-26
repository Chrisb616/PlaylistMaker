//
//  CBError.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 2/14/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import UIKit

/**
 Custom error class for handling errors within this application.
 */
struct CBError {
    var swiftError: Error?
    var debugString: String?
    var userDisplayString: String?
    
    init(debugString: String?, userDisplayString: String?, swiftError: Error? = nil) {
        self.debugString = debugString
        self.userDisplayString = userDisplayString
        self.swiftError = swiftError
    }
    
    func displayAlert(onViewController viewController: UIViewController) {
        print("CBERROR: \(debugString ?? "No Debug String")")
        
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Something went wrong...", message: self.userDisplayString ?? "Please Try Again", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            
            viewController.present(alert, animated: true, completion: nil)
        }
    }
}
