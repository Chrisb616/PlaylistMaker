//
//  Playlist.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 2/4/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation
import RealmSwift

class Playlist: Object {
    
    @objc dynamic var name: String?
    @objc dynamic var contentDescription: String?
    @objc dynamic var creationDate: Date?
    
    var tracks = List<PlaylistTrack>()
}

class PlaylistTrack: Object {
    @objc dynamic var trackName: String?
    @objc dynamic var artistName: String?
    @objc dynamic var albumName: String?
}
