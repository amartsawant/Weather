//
//  WeatherViewModel.swift
//  Weather
//
//  Created by Amar Sawant on 18/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import Foundation 

private enum City: Int, CaseIterable {
    case london = 2643743
    case paris = 2968815
    case random
    
    var backgroundImage: String {
        switch self {
        case .london:return "london"
        case .paris: return "paris"
        case .random: return "default"
        }
    }
}

class WeatherViewModel {
    var weatherReport: WeatherReport?
    let interactor: WeatherDataInteractor?
    private let placeDataInteractor: PlaceDataInteractor?

    init(interactor: WeatherDataInteractor, dataHandler: PlaceDataInteractor) {
        self.interactor = interactor
        self.placeDataInteractor = dataHandler
    }
    
    func titleForView() -> String {
        return "Weather Report"
    }
    
    func numberOfItems() -> Int {
        return weatherReport?.list.count ?? 0
    }
    
    func weatherDataAtIndex(_ index: Int) -> WeatherData? {
        if let weatherDataList = weatherReport?.list, index < weatherDataList.count {
            return weatherDataList[index]
        }
        return nil
    }
    
    func humidityForItemAtIndex(index: Int) -> String? {
        if let data = weatherDataAtIndex(index) {
            let humidity = data.humidity
            let unit: String = "%"
            return String.localizedStringWithFormat("%.f%@", humidity, unit)
        }
        return nil
    }
    
    func tempuratureForItemAtIndex(index: Int) -> String? {
        if let data = weatherDataAtIndex(index) {
            let temp = data.tempurature
            let unit: String = "°"
            return String.localizedStringWithFormat("%@%@", temp.kelvinToCelcius, unit)
        }
        return nil
    }
    
    func sunriseTimeForItemAtIndex(index: Int) -> String? {
        if let data = weatherDataAtIndex(index) {
            return unixTimeConvertion(time: data.sunrise)
        }
        return nil
    }
    
    func sunsetTimeForItemAtIndex(index: Int) -> String? {
        if let data = weatherDataAtIndex(index) {
            return unixTimeConvertion(time: data.sunset)
        }
        return nil
    }
    
    func cityNameForItemAtIndex(index: Int) -> String? {
        if let data = weatherDataAtIndex(index) {
            return data.city
        }else {
            return nil
        }
    }
    
    func removeSelectedPlaceAtIndex(index: Int) {
        if let weatherReport = weatherReport, weatherReport.list.count > index {
             let weatherData = weatherReport.list[index]
                placeDataInteractor?.removeSelectedPlace(placeId: weatherData.id)
            
        }
    }
    
    func imageForItemAtIndex(index: Int) -> String {
        
        if let data = weatherDataAtIndex(index) {
            switch data.id {
            case City.london.rawValue:
                return City.london.backgroundImage
            case City.paris.rawValue:
                return City.paris.backgroundImage
            default:
                return City.random.backgroundImage
            }
        }else {
            return City.random.backgroundImage
        }
    }
    
    func fetchWeatherReport(completion: @escaping (Error?) -> ()) {
        let selectedPlaces = placeDataInteractor?.getSelectedPlaces() ?? [:]
        
        if selectedPlaces.count > 0 {
        interactor?.featchWeatherData(for: selectedPlaces) { data, error in
            if let error = error {
                completion(error)
                return
            }
            
            if let data = data {
                self.weatherReport = data
                completion(nil)
            }
        }
        }else {
            self.weatherReport = nil
            completion(nil)
        }
        
    }
    
    func unixTimeConvertion(time: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.system.identifier) as Locale
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: time as Date)
    }
}
