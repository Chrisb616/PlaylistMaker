//
//  Factbook.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/30/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation

class Factbook {
    private init() {}
    
    static func totalDaysFor(month: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12: return 31
        case 4, 6, 9, 11: return 30
        case 2: return 29
        default: return 0
        }
    }
}
