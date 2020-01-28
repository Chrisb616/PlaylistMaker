//
//  Album.swift
//  PlaylistMaker
//
//  Created by Christopher Boynton on 1/28/20.
//  Copyright © 2020 Christopher Boynton. All rights reserved.
//

import Foundation

struct Album: Codable {
    var text: String
    
    private enum CodingKeys: String, CodingKey {
        case text = "#text"
    }
}
