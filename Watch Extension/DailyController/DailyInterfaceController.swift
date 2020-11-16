//
//  DailyInterfaceController.swift
//  Watch Extension
//
//  Created by Duy Dinh on 13/11/2020.
//

import WatchKit

class DailyInterfaceController: WKInterfaceController {

    @IBOutlet var table: WKInterfaceTable!
    
    var dataArray: [Daily] = []
    var parameter: [String: Any] = ["units": "metric", "exclude": "hourly,current,minutely,alerts", "appid": Domain.appid]
    
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        // Configure interface objects here.
        if let coord = context as? Coordinate {
            getData(coord: coord)
        } else {
            print("error")
        }
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    func getData(coord: Coordinate) {
        parameter["lon"] = coord.lon
        parameter["lat"] = coord.lat
        requestApi().request(parameter: parameter, headers: Domain.headers) { data, error in
            guard let data = data, error == nil else { return }
            self.dataArray = data
            DispatchQueue.main.async {
                self.table.setNumberOfRows(self.dataArray.count, withRowType: "DailyRow")
                for index in 0..<self.dataArray.count {
                    guard let controller = self.table.rowController(at: index) as? DailyRowController else { return }
                    controller.daily = self.dataArray[index]
                }
            }
        }
    }
}
