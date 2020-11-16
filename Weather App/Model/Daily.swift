//
//  Daily.swift
//  Weather
//
//  Created by Duy Dinh on 11/1/20.
//

import Foundation

struct Daily: Codable {
    var dt: Double?
    var temp: Temp
    var weather: [Weather]
}
