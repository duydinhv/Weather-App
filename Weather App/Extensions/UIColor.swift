//
//  UIColor.swift
//  Weather App
//
//  Created by Duy Dinh on 11/8/20.
//

import UIKit

extension UIColor {
    public convenience init?(hex: String) {
            let r, g, b: CGFloat

            if hex.hasPrefix("#") {
                let start = hex.index(hex.startIndex, offsetBy: 1)
                let hexColor = String(hex[start...])

                if hexColor.count == 6 {
                    let scanner = Scanner(string: hexColor)
                    var hexNumber: UInt64 = 0

                    if scanner.scanHexInt64(&hexNumber) {
                        r = CGFloat((hexNumber  >> 16) & 0xff) / 255
                        g = CGFloat((hexNumber >> 8) & 0xff ) / 255
                        b = CGFloat((hexNumber & 0xff)) / 255
                        self.init(red: r, green: g, blue: b, alpha: 0.5)
                        return
                    }
                }
            }

            return nil
        }

}
