//
//  Track.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/28/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation

struct Track: Codable {
    var artist: Artist
    var album: Album
    var name: String
    var date: TrackDate?
}
