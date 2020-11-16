//
//  InterfaceController.swift
//  Watch Extension
//
//  Created by Duy Dinh on 13/11/2020.
//

import WatchKit
import Foundation
import CoreLocation

class MainInterfaceController: WKInterfaceController {
    
    typealias Coordinate2D = CLLocationCoordinate2D
    @IBOutlet var table: WKInterfaceTable!
    
    var dataArray: [Location] = []
    var parameter: [String: Any] = ["appid": Domain.appid, "units": "metric"]
    var coords: [Coordinate2D] = []
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        LocationManager.shared.startUpdating { location in
            self.coords = [location.coordinate,
                     Coordinate2D(latitude: 10.75, longitude: 106.67),
                     Coordinate2D(latitude: 21.02, longitude: 105.84)
                        ]
            self.getData()
        }
        
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }
    
    override func table(_ table: WKInterfaceTable, didSelectRowAt rowIndex: Int) {
        let context = dataArray[rowIndex].coord
        presentController(withName: "DailyIC", context: context)
    }
    
    func getData() {
        for coord in coords {
            self.parameter["lon"] = coord.longitude
            self.parameter["lat"] = coord.latitude
            LocationService().locationRequest(parameter: parameter, headers: Domain.headers) { data, error in
                guard let data = data, error == nil else { return }
                self.dataArray.append(data)
                DispatchQueue.main.async {
                    self.table.setNumberOfRows(self.dataArray.count, withRowType: "MainRow")
                    for index in 0..<self.table.numberOfRows {
                        guard let controller = self.table.rowController(at: index) as? RowController else { return }
                        controller.location = self.dataArray[index]
                    }
                }
            }
        }
    }
}
