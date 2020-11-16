//
//  APIResponse.swift
//  Weather
//
//  Created by Duy Dinh on 10/30/20.
//

import Foundation

struct APIResponse: Codable {
    var lat: Float?
    var lon: Float?
    var daily: [Daily]?
}

