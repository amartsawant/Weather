//
//  DataManager.swift
//  Weather
//
//  Created by Amar Sawant on 20/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import Foundation

typealias completion = (([PlaceData]?, Error?) -> Void)


class DataManager {
    
    static let shared = DataManager()
    private let defaults = UserDefaults.standard
    private let selectedPlacesKey = "selectedPlaces"
    private let storeKey = "allPlaces"
    
    private init() {
        //add default selected cities
        addSelectedPlace(2968815) //Paris
        addSelectedPlace(2643743) //London
    }
    
    func getAllPlaces(_ completion: completion) {
        if let places = cachedPlaces() {
            completion(places, nil)
        }else {
            loadJsonData(filename: "city") { (places, error) in
                completion(places, error)
            }
        }
    }
    
    // MARK: - All places
    func cachedPlaces() -> [PlaceData]? {
        return defaults.object(forKey: storeKey) as? [PlaceData]
    }
    
    func cacheAllPlaces(places: [PlaceData]) {
        defaults.set(places, forKey: storeKey)
    }
    
    func deleteCache() {
        defaults.removeObject(forKey: storeKey)
    }
    
    // MARK: - Selected places
    func getSelectedPlaces() -> [String:Int] {
        return defaults.object(forKey: selectedPlacesKey) as? [String:Int] ?? [:]
    }
    
    func addSelectedPlace(placeId: Int) {
        addSelectedPlace(placeId)
    }
    
    func removeSelectedPlace(placeId: Int) {
        deleteSelectedPlace(placeId)
    }
    
    private func addSelectedPlace(_ placeId: Int) {
        var selectedPlaces = defaults.object(forKey: selectedPlacesKey) as? [String:Int] ?? [:]
        selectedPlaces[String(placeId)] = placeId
        defaults.set(selectedPlaces, forKey: selectedPlacesKey)
    }
    
    private func deleteSelectedPlace(_ placeId: Int) {
        var selectedPlaces = defaults.object(forKey: selectedPlacesKey) as? [String:Int] ?? [:]
        selectedPlaces.removeValue(forKey: String(placeId))
        defaults.set(selectedPlaces, forKey: selectedPlacesKey)
    }
    
}

extension DataManager {
    
    func loadJsonData(filename fileName: String, completion: completion) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let places = try decoder.decode([PlaceData].self, from: data)
                completion(places, nil)
            }catch {
                debugPrint("error:\(error)")
                completion(nil, error)
            }
        }
    }
    
}
