//
//  User.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/31/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation

class User: Codable {
    var name: String
    var playcount: String
    var country: String
    var realname: String
    var registered: RegisteredDate
    var image: [UserImage]
}

class RegisteredDate: Codable {
    var unixtime: String
    
    var date: Date? {
        guard let timeInterval = TimeInterval(unixtime) else {
            return nil
        }
        
        return Date(timeIntervalSince1970: timeInterval)
    }
}

class UserImage: Codable {
    var size: String
    var url: String
    
    private enum CodingKeys: String, CodingKey {
        case size, url = "#text"
    }
}
