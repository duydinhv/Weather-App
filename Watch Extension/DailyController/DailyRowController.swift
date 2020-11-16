//
//  DailyRowController.swift
//  Watch Extension
//
//  Created by Duy Dinh on 13/11/2020.
//

import WatchKit

class DailyRowController: NSObject {
    @IBOutlet var dateLabel: WKInterfaceLabel!
    @IBOutlet var tempLabel: WKInterfaceLabel!
    @IBOutlet var highLowTempLabel: WKInterfaceLabel!
    @IBOutlet var iconImage: WKInterfaceImage!
    
    var daily: Daily? {
        didSet {
            guard let daily = daily else { return }
            dateLabel.setText(daily.dt?.toDate())
            tempLabel.setText(daily.temp.eve.tempFormat())
            highLowTempLabel.setText("H:\(daily.temp.max.tempFormat()) L:\(daily.temp.min.tempFormat())")
            let icon = daily.weather.first?.icon
            DownloadService.shared.downloadImage(path: icon ?? "01d") { data, error in
                guard let data = data, error == nil else { return }
                self.iconImage.setImage(data)
            }
        }
    }
}
