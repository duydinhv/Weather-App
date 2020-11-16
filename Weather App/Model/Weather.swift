//
//  Weather.swift
//  Weather
//
//  Created by Duy Dinh on 10/27/20.
//

import Foundation

struct Weather: Codable {
    var id: Int?
    var main: String?
    var description: String?
    var icon: String?
    
    init(id: Int, main: String, description: String, icon: String) {
        self.id = id
        self.main = main
        self.description = description
        self.icon = icon
    }
}
