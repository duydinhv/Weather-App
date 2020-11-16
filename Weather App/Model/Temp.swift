//
//  Temp.swift
//  Weather App
//
//  Created by Duy Dinh on 11/2/20.
//

import Foundation

struct Temp: Codable {
    var eve: Float
    var min: Float
    var max: Float
    
    init(eve: Float, max: Float, min: Float) {
        self.eve = eve
        self.max = max
        self.min = min
    }
}
