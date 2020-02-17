//
//  Date.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/28/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation

extension Date {
    
    static func fromComponents(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date? {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "y-M-d-H-m-s"
        
        return dateFormatter.date(from: "\(year)-\(month)-\(day)-\(hour)-\(minute)-\(second)")
    }
    
    var month: Int {
        return Calendar.current.dateComponents([.month], from: self).month ?? 0
    }
    var day: Int {
        return Calendar.current.dateComponents([.day], from: self).day ?? 0
    }
    var year: Int {
        return Calendar.current.dateComponents([.year], from: self).year ?? 0
    }
    var second: Int {
        return Calendar.current.dateComponents([.second], from: self).second ?? 0
    }
    var minute: Int {
        return Calendar.current.dateComponents([.minute], from: self).minute ?? 0
    }
    var hour: Int {
        return Calendar.current.dateComponents([.hour], from: self).hour ?? 0
    }
    
    //Date formatted as string in simple function
    func formatted(as string: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = string
        return formatter.string(from: self)
    }
    
    //Use that function to find the weekday as a string
    var weekday: String {
        return self.formatted(as: "EEEE")
    }
    
    func yearsSince(_ date: Date) -> Int {
        if date.month < self.month {
            return self.year - date.year
        } else if date.month > self.month {
            return self.year - date.year - 1
        } else {
            if date.day <= self.day {
                return self.year - date.year
            } else {
                return self.year - date.year - 1
            }
        }
    }
    
    func monthsSince(_ date: Date) -> Int {
        if date.day <= self.day {
            return (self.year - date.year) * 12 + (self.month - date.month)
        } else {
            return (self.year - date.year) * 12 + (self.month - date.month - 1)
        }
    }
}
