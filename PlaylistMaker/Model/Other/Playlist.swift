//
//  Playlist.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 2/4/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation

class Playlist {
    
    var name: String
    var contentDescription: String
    
    var tracks: [Track]
    
    var creationDate: Date
    
    init(name: String, contentDescription: String, tracks: [Track]) {
        self.name = name
        self.contentDescription = contentDescription
        self.tracks = tracks
        self.creationDate = Date()
    }
    
}
