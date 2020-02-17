//
//  PlaylistService.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 2/4/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation
import RealmSwift

class PlaylistService {
    static let instance = PlaylistService()
    private init() { }
    
    func createPlaylistForTimeRange(starting startDate: Date, ending endDate: Date, username: String, playlistName: String, completion: @escaping (Playlist)->()) {
        ScrobblesService.instance.allTracksForDateRange(startDate: startDate, endDate: endDate, username: username) { (scrobbles, errorString) in
            let catalog = Catalog(scrobbles: scrobbles)
            
            let topTen = Array(catalog.topTracks[0...9]).map { (track) -> PlaylistTrack in
                let playlistTrack = PlaylistTrack()
                playlistTrack.trackName = track.trackName
                playlistTrack.artistName = track.artistName
                return playlistTrack
            }
            
            let playlist = Playlist()
            playlist.name = playlistName
            playlist.tracks = List<PlaylistTrack>()
            playlist.tracks.append(objectsIn: topTen)
            
            completion(playlist)
        }
    }
}
