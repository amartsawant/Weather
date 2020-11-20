//
//  WeatherDataInteractor.swift
//  Weather
//
//  Created by Amar Sawant on 18/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import Foundation

typealias weatherDataCompletionHandler = ((WeatherReport?, Error?) -> Void)

class WeatherDataInteractor {
    private let url = ""
    private let serviceManager = ServiceManager()
    
    private var apiKey: String? {// TO DO :: move to safe store
        return Bundle.main.object(forInfoDictionaryKey: "APIKey") as? String
    }
    
    func featchWeatherData(for places: [String: Int], completion: @escaping weatherDataCompletionHandler) -> Void {
        
        let selectedPlaces = (places.values.map{String($0)}).joined(separator: ",")
        let url = "https://api.openweathermap.org/data/2.5/group?id=\(selectedPlaces)&APPID=\(apiKey ?? "")"
        serviceManager.featchRemoteData(with: url) { (data, err) in
            
            if let error = err {
                completion(nil, error)
                return
            }
            
            if let data = data {
                if let WeatherReport = WeatherDataParser().parseWeatherData(data: data) {
                    completion(WeatherReport, nil)
                }
            }
        }
    }
    
}
