//
//  ScrobblesService.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/30/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation

class ScrobblesService {
    
    static let instance = ScrobblesService()
    private init(){}
    
    func allTracksForMonth(year: Int, month: Int, completion: @escaping ([Track], String?)->()) {
        
        guard
            let startDate = Date.fromComponents(year: year, month: month, day: 1, hour: 0, minute: 0, second: 0),
            let endDate = Date.fromComponents(year: year, month: month, day: Factbook.totalDaysFor(month: month), hour: 23, minute: 59, second: 59)
        else {
            completion([],"Invalid Date")
            return
        }
        
        APIClient.instance.getRecentTracksfrom(startDate, to: endDate) { (responses, errorString) in
            var allTracks = [Track]()
            
            for response in responses {
                if let tracks = response.recenttracks?.track {
                    let filteredTracks = tracks.filter { $0.date != nil }
                    allTracks.append(contentsOf: filteredTracks)
                }
            }
            
            completion(allTracks, nil)
        }
        
    }
    
    func allTracksForDateAllYears(month: Int, day: Int, completion: @escaping ([Track], String?)->()) {
        var allTracks = [Track]()
        
        let allYears: [Int] = Array(2002...Date().year)
        var completedYears = [Int]()
        
        for year in allYears {
            allTracksForDate(year: year, month: month, day: day) { (tracks, errorString) in
                
                DispatchQueue.main.async {
                    allTracks.append(contentsOf: tracks)
                    
                    completedYears.append(year)
                    print("Completed \(completedYears.count) of \(allYears.count) years")
                    
                    if (completedYears.count == allYears.count) {
                        completion(allTracks,errorString)
                    }
                }
            }
        }
        
    }
    
    func allTracksForDate(year: Int, month: Int, day: Int, completion: @escaping ([Track], String?)->()) {
        
        guard
            let startDate = Date.fromComponents(year: year, month: month, day: day, hour: 0, minute: 0, second: 0),
            let endDate = Date.fromComponents(year: year, month: month, day: day, hour: 23, minute: 59, second: 59)
        else {
            completion([],"Invalid Date")
            return
        }
        
        APIClient.instance.getRecentTracksfrom(startDate, to: endDate) { (responses, errorString) in
            
            var allTracks = [Track]()
            
            for response in responses {
                if let tracks = response.recenttracks?.track {
                    let filteredTracks = tracks.filter { $0.date != nil }
                    allTracks.append(contentsOf: filteredTracks)
                }
            }
            
            completion(allTracks, nil)
        }
    }
    
}
