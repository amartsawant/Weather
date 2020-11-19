//
//  WeatherDataParser.swift
//  Weather
//
//  Created by Amar Sawant on 18/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import Foundation

class WeatherDataParser {
    
    func parseWeatherData(data: Data) -> WeatherData? {
        let decoder = JSONDecoder()
        do {
            decoder.dateDecodingStrategy = .secondsSince1970
            let data = try decoder.decode(WeatherData.self, from: data)
            return data
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
