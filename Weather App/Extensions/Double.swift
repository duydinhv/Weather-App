//
//  Double.swift
//  Weather App
//
//  Created by Duy Dinh on 11/3/20.
//

import Foundation

extension Double {
    func toLongDate() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
    
    func toDate() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}
