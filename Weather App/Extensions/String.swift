//
//  String.swift
//  Weather App
//
//  Created by Duy Dinh on 11/3/20.
//

import Foundation

extension String {
    func toDate(withFormat format: String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        guard let date = dateFormatter.date(from: self) else {
            preconditionFailure("Take a look to your format")
        }
        return date
    }
    
    mutating func captilizeFirstLetter() {
        self = self.prefix(1).capitalized + dropFirst()
    }
}
