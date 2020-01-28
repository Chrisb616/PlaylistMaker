//
//  TrackDate.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/28/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation

struct TrackDate: Codable {
    var uts: String?
    var text: String?
    
    private enum CodingKeys: String, CodingKey {
        case uts, text = "#text"
    }
}
