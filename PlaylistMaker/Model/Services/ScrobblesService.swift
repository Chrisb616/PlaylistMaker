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
    
    func allTracksForMonthAllYears(month: Int, username: String, completion: @escaping ([Track], CBError?)->()) {
        var allTracks = [Track]()
        
        let allYears = Factbook.allYears
        var completedYears = [Int]()
        
        for year in allYears {
            allTracksForMonth(year: year, month: month, username: username) { (tracks, error) in
                DispatchQueue.main.async {
                    allTracks.append(contentsOf: tracks)

                    completedYears.append(year)
                    print("Completed \(completedYears.count) of \(allYears.count) years")

                    if (completedYears.count == allYears.count) {
                        completion(allTracks,error)
                    }
                }
            }
        }
    }
    
    func allTracksForMonth(year: Int, month: Int, username: String, completion: @escaping ([Track], CBError?)->()) {
        allTracksForDateRange(startYear: year, startMonth: month, startDay: 1, endYear: year, endMonth: month, endDay: Factbook.totalDaysFor(month: month, year: year), username: username) { (tracks, error) in
            completion(tracks,error)
        }
    }
    
    func allTracksForDateAllYears(month: Int, day: Int, username: String, completion: @escaping ([Track], CBError?)->()) {
        var allTracks = [Track]()
        
        let allYears = Factbook.allYears
        var completedYears = [Int]()
        
        for year in allYears {
            allTracksForDate(year: year, month: month, day: day, username: username) { (tracks, error) in
                
                DispatchQueue.main.async {
                    allTracks.append(contentsOf: tracks)
                    
                    completedYears.append(year)
                    print("Completed \(completedYears.count) of \(allYears.count) years")
                    
                    if (completedYears.count == allYears.count) {
                        completion(allTracks,error)
                    }
                }
            }
        }
    }
    
    func allTracksForDate(year: Int, month: Int, day: Int, username: String, completion: @escaping ([Track], CBError?)->()) {
        allTracksForDateRange(startYear: year, startMonth: month, startDay: day, endYear: year, endMonth: month, endDay: day, username: username) { (tracks, error) in
            completion(tracks, error)
        }
    }
    
    /**
     Find all tracks for given date range, repeated every year. Note that if the date provide for start is later than the year provided for end, this method will consider the date range stretching over the new year.
     */
    func allTracksForDateRangeAllYears(startMonth: Int, startDay: Int, endMonth: Int, endDay: Int, username: String, completion: @escaping ([Track], CBError?)->()) {
        let rangeCoversNewYear: Bool = startMonth > endMonth || (startMonth == endMonth && startDay > endDay)
        
        var allTracks = [Track]()
        
        let allYears = Factbook.allYears
        var completedYears = [Int]()
        
        for year in allYears {
            let endYear = rangeCoversNewYear ? year + 1 : year
            
            allTracksForDateRange(startYear: year, startMonth: startMonth, startDay: startDay, endYear: endYear, endMonth: endMonth, endDay: endDay, username: username) { (tracks, error) in
                
                DispatchQueue.main.async {
                    allTracks.append(contentsOf: tracks)
                    
                    completedYears.append(year)
                    print("Completed \(completedYears.count) of \(allYears.count) years")
                    
                    if (completedYears.count == allYears.count) {
                        completion(allTracks,error)
                    }
                }
            }
        }
    }
    
    func allTracksForDateRange(startYear: Int, startMonth: Int, startDay: Int, endYear: Int, endMonth: Int, endDay: Int, username: String, completion: @escaping ([Track], CBError?)->()) {
        
        guard
            let startDate = Date.fromComponents(year: startYear, month: startMonth, day: startDay, hour: 0, minute: 0, second: 0),
            let endDate = Date.fromComponents(year: endYear, month: endMonth, day: endDay, hour: 23, minute: 59, second: 59)
        else {
            let error = CBError(debugString: "Couldn't create dates for date range", userDisplayString: "There was a problem loading tracks for this user.")
            completion([],error)
            return
        }
        
        allTracksForDateRange(startDate: startDate, endDate: endDate, username: username) { (tracks, errorString) in
            completion(tracks, errorString)
        }
    }
    
    func allTracksForDateRange(startDate: Date, endDate: Date, username: String, completion: @escaping ([Track], CBError?)->()) {
        
        APIClient.instance.getRecentTracksfrom(startDate, to: endDate, username: username) { (responses, errorString) in
            
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
