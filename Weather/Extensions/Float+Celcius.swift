//
//  Float+Celcius.swift
//  Weather
//
//  Created by Amar Sawant on 20/11/20.
//  Copyright © 2020 atsawant.com. All rights reserved.
//

import Foundation

extension Float {
    
    var truncateRemainder: String {
       return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
    
    var kelvinToCelcius: String {
        let tempInCelcius: Float = self - 273.15
        return String.localizedStringWithFormat("%@", tempInCelcius.truncateRemainder)
    }
}
