//
//  RowController.swift
//  Watch Extension
//
//  Created by Duy Dinh on 13/11/2020.
//

import WatchKit

class RowController: NSObject {
    @IBOutlet var locationLabel: WKInterfaceLabel!
    @IBOutlet var tempLabel: WKInterfaceLabel!
    @IBOutlet var iconImage: WKInterfaceImage!
    
    var location: Location? {
        didSet {
            guard let location = location else { return }
            locationLabel.setText(location.name)
            tempLabel.setText(location.main?.temp?.tempFormat())
            let icon = location.weather?.first?.icon
            DownloadService.shared.downloadImage(path: icon ?? "01d") { data, error in
                guard let data = data, error == nil else { return }
                self.iconImage.setImage(data)
            }
        }
    }
}
