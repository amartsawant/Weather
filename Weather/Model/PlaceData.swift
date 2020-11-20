//
//  PlaceData.swift
//  Weather
//
//  Created by Amar Sawant on 20/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import Foundation

struct PlaceData: Decodable {
    let id: Int
    let name: String
    let country: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case country
    }
}
