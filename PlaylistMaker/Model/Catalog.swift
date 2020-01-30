//
//  Catalog.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/30/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation

class Catalog {
    
    private var _scrobbles: [Track]
    var scrobbles: [Track] { return _scrobbles }
    
    private var _tracks = [String:CatalogTrack]()
    var tracks: [String: CatalogTrack] { return _tracks }
    
    private var _artists = [String:CatalogArtist]()
    var artists: [String:CatalogArtist] { return _artists }
    
    init(scrobbles: [Track]) {
        _scrobbles = scrobbles
        
        setUpCatalog()
    }
    
    private func setUpCatalog() {
        for scrobble in scrobbles {
            
            let trackName = scrobble.name
            let artistName = scrobble.artist.text
            let trackFullName = "\(trackName) - \(artistName)"
            
            if let track = tracks[trackFullName] {
                track.count += 1
            } else {
                let track = CatalogTrack(trackName: trackName, artistName: artistName)
                track.count += 1
                _tracks.updateValue(track, forKey: track.fullName)
            }
            
            if let artist = artists[artistName] {
                artist.count += 1
            } else {
                let artist = CatalogArtist(name: artistName)
                artist.count += 1
                _artists.updateValue(artist, forKey: artist.name)
            }
        }
    }
    
    var topTracks: [CatalogTrack] {
        var allTracks = Array(_tracks.values)
        
        allTracks.sort{ $0.count > $1.count }
        
        return allTracks
    }
}

class CatalogTrack {
    
    var trackName: String
    var artistName: String
    var count: Int
    
    var fullName: String { return "\(trackName) - \(artistName)" }
    
    init(trackName: String, artistName: String) {
        self.trackName = trackName
        self.artistName = artistName
        self.count = 0
    }
}

class CatalogArtist {
    var name: String
    var count: Int
    
    init(name: String) {
        self.name = name
        self.count = 0
    }
}
