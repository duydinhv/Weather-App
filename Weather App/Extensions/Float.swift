//
//  String.swift
//  Weather App
//
//  Created by Duy Dinh on 11/2/20.
//

import UIKit

extension Float {
    func tempFormat() -> String {
        let value: Int = Int(self)
        return String(describing: "\(value)°C")
    }
}
