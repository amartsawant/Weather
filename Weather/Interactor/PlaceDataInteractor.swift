//
//  PlaceDataInteractor.swift
//  Weather
//
//  Created by Amar Sawant on 20/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import Foundation

class PlaceDataInteractor {
    let dataManager = DataManager.shared
    
    func getAllPlaces(_ completion: @escaping completion) {
        dataManager.getAllPlaces { (places, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let places = places {
                completion(places, nil)
            }
        }
    }
    
    func getSelectedPlaces() -> [String : Int]? {
        return dataManager.getSelectedPlaces()
    }
    
    func addSelectedPlace(placeId: Int) {
        dataManager.addSelectedPlace(placeId: placeId)
    }
    
    func removeSelectedPlace(placeId: Int) {
        dataManager.removeSelectedPlace(placeId: placeId)
    }
}
