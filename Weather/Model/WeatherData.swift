//
//  WeatherData.swift
//  Weather
//
//  Created by Amar Sawant on 18/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import Foundation

struct WeatherData: Decodable {
    let id: Int
    let city: String
    let sunrise: Date
    let sunset: Date
    let tempurature: Float
    let humidity: Float
    
    enum CodingKeys: String, CodingKey {
        case id
        case main
        case sys
        case city = "name"
        
        enum MainKeys: String, CodingKey {
            case humidity
            case tempurature = "temp"
        }
        
        enum SystemKeys: String, CodingKey {
            case sunrise
            case sunset
        }
    }
    
    
    
    init(from decoder: Decoder) throws {
//        do {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(Int.self, forKey: .id)
            city = try container.decode(String.self, forKey: .city)
           
            let mainContainer = try container.nestedContainer(keyedBy: CodingKeys.MainKeys.self, forKey: .main)
            humidity = try mainContainer.decode(Float.self, forKey: .humidity)
            tempurature = try mainContainer.decode(Float.self, forKey: .tempurature).kelvinToCelcius()

            let sysContainer = try container.nestedContainer(keyedBy: CodingKeys.SystemKeys.self, forKey: .sys)
            sunrise = try sysContainer.decode(Date.self, forKey: .sunrise)
            sunset = try sysContainer.decode(Date.self, forKey: .sunset)
            
//        } catch {
//            debugPrint("handle parse error")
//        }
    
    }
}

extension Float {
    func kelvinToCelcius() -> Float {
        return self - 273.15
    }
}
