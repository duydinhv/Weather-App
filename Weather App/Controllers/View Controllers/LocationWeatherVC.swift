//
//  LocationWeatherVC.swift
//  Weather App
//
//  Created by Duy Dinh on 11/4/20.
//

import UIKit
import CoreLocation

protocol LocationWeatherDelegate: class {
    func passCoordinate(longitude: Double, latitude: Double)
}

enum cellBackgroundColor {
    case clear
    case rain
    case storm
    case mist
    
    var color: UIColor? {
        switch self {
        case .clear:
            return UIColor(hex: "#ffb266")
        case .rain:
            return UIColor(hex: "#6666FF")
        case .storm:
            return UIColor(hex: "#A0A0A0")
        default:
            return UIColor(hex: "#FFFFFF")
        }
    }
}

typealias Coordinate2D = CLLocationCoordinate2D

class LocationWeatherVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: LocationWeatherDelegate?
    
    var dataArray: [Location] = []
    var parameter: [String: Any] = ["appid": Domain.appid, "units": "metric"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        let location = LocationManager.shared.location
        let lon: Double = location?.coordinate.longitude ?? 0
        let lat: Double = location?.coordinate.latitude ?? 0
        let coordinates: [Coordinate2D] = [Coordinate2D(latitude: lat, longitude: lon),
                                           Coordinate2D(latitude: 10.75, longitude: 106.67),
                                           Coordinate2D(latitude: 21.02, longitude: 105.84)]
        
        for coordinate in coordinates {
            self.requestAPIWeather(longitude: coordinate.longitude, latitude: coordinate.latitude)
        }

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func requestAPIWeather(longitude: Double, latitude: Double) {
        self.parameter["lon"] = longitude
        self.parameter["lat"] = latitude
        LocationService().locationRequest(parameter: parameter, headers: Domain.headers) { [weak self] data, error in
            guard let data = data, error == nil else { return }
            self?.dataArray.append(data)
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
        
    }
}

extension LocationWeatherVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        let icon = dataArray[indexPath.row].weather?.last?.icon ?? "01d"
        cell.setBackgroundColor(icon: icon)
        cell.titleLabel.text = dataArray[indexPath.row].name
        cell.tempLabel.text = Float(dataArray[indexPath.row].main?.temp ?? 0).tempFormat()
        cell.weatherLabel.text = dataArray[indexPath.row].weather?.last?.description
        DownloadService.shared.downloadImage(path: (dataArray[indexPath.row].weather?.last?.icon ?? "01d")) { data, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.iconImageView.image = data
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.passCoordinate(longitude: Double(self.dataArray[indexPath.row].coord?.lon ?? 0),
                                 latitude: Double(self.dataArray[indexPath.row].coord?.lat ?? 0))
        print("longitude \(self.dataArray[indexPath.row].coord?.lon)")
        self.navigationController?.popViewController(animated: true)
    }
}

