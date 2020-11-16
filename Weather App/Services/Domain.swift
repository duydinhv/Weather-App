//
//  Domain.swift
//  Weather
//
//  Created by Duy Dinh on 10/30/20.
//

import Foundation

struct Domain: Codable {
    static var headers = ["Accept": "application/json"]
    static let appid = "08feb95078d3f88886ddbf99a2bfd310"
    static let currentDataUrl = "https://api.openweathermap.org/data/2.5/weather?"
    static let dailyForecast7DaysUrl = "https://api.openweathermap.org/data/2.5/onecall?"
    static let getIconUrl = "https://openweathermap.org/img/wn/"
}
