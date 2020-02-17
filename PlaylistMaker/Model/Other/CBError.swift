//
//  CBError.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 2/14/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation

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
}
