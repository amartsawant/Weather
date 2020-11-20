//
//  CountryListViewModel.swift
//  Weather
//
//  Created by Amar Sawant on 18/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import Foundation

class CountryListViewModel {
    private var places: [PlaceData]?
    
    private lazy var selectedPlaces: [String : Int]? = {
        return self.interactor?.getSelectedPlaces()
    }()

    let interactor: PlaceDataInteractor?
    
    init(dataHandler: PlaceDataInteractor) {
        self.interactor = dataHandler
    }
    
    func numberOfItems() -> Int {
        return places?.count ?? 0
    }
    
    func placeInfoAtIndex(_ index: Int) -> PlaceData? {
        if let places = places, index < places.count {
            return places[index]
        }
        return nil
    }
    
    func cityNameForPlaceAtIndex(index: Int) -> String? {
        if let place = placeInfoAtIndex(index) {
            return place.name
        }
        return nil
    }
    
    func countryForPlaceAtIndex(index: Int) -> String? {
        if let place = placeInfoAtIndex(index) {
            return place.country
        }
        return nil
    }
    
    func idForPlaceAtIndex(index: Int) -> Int? {
        if let place = placeInfoAtIndex(index) {
            return place.id
        }
        return nil
    }
    
    func isPlaceSelected(id: Int) -> Bool {
        if let selectedPlaces = selectedPlaces {
        return selectedPlaces[String(id)] != nil
        }
       return false
    }
    
    func setSelectedPlaceatIndex(index: Int) {
        if let id = idForPlaceAtIndex(index: index) {
            interactor?.addSelectedPlace(placeId: id)
        }
    }
    
    func getAllPlaces(_ completion: @escaping completion) {
        
        interactor?.getAllPlaces({ (places, error) in
            if let error = error {
                completion(nil, error)
                return
            }
            
            if let places = places {
                self.places = places
                completion(places, nil)
            }
        })
    }
}
