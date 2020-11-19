//
//  WeatherDataInteractor.swift
//  Weather
//
//  Created by Amar Sawant on 18/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import Foundation

typealias weatherDataCompletionHandler = ((WeatherData?, Error?) -> Void)

class WeatherDataInteractor {
    private let url = ""
    private let key = "" // TO DO :: move to safe store
    private let serviceManager = ServiceManager()
    
    func featchWeatherData(for city: String, completion: @escaping weatherDataCompletionHandler) -> Void {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=London,uk&APPID=d88ad2918fc6f0faf000bfe39b988e91"
        
        serviceManager.featchRemoteData(with: url) { (data, err) in
            
            if let error = err {
                completion(nil, error)
                return
            }
            
            if let data = data {
                if let weatherData = WeatherDataParser().parseWeatherData(data: data) {
                    completion(weatherData, nil)
                }
            }
        }
    }
}
