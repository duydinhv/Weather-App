//
//  Location.swift
//  Weather App
//
//  Created by Duy Dinh on 11/4/20.
//

import Foundation

struct Location: Codable {
    var coord: Coordinate?
    var weather: [Weather]?
    var name: String?
    var main: Main?
    
    init(coord: Coordinate, weather: [Weather], name: String, main: Main) {
        self.coord = coord
        self.weather = weather
        self.name = name
        self.main = main
    }
}
