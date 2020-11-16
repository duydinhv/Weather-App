//
//  ViewController.swift
//  Weather App
//
//  Created by Duy Dinh on 11/2/20.
//

import UIKit

class DateWeatherVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    let notifications = Notifications()
    var weathers: [Daily] = []
    var parameter: [String: Any] = ["units": "metric", "exclude": "hourly,current,minutely,alerts", "appid": Domain.appid]
    #if RELEASE
    
    #endif
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 1))
        tableView.sectionHeaderHeight = CGFloat.leastNonzeroMagnitude
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "cell")
        
        LocationManager.shared.startUpdating { location in
            self.parameter["lon"] = location.coordinate.longitude
            self.parameter["lat"] = location.coordinate.latitude
            self.requestAPIWeather()
            #if RELEASE
            self.longitude = location.coordinate.longitude
            self.latitude = location.coordinate.latitude
            #endif
        }
    }
    
    func requestAPIWeather() {
        requestApi().request(parameter: self.parameter, headers: Domain.headers) { [weak self] data, error in
            guard let data = data, error == nil else { return }
            self?.weathers = data
            DispatchQueue.main.async {
                self?.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.string(forKey: "time") != nil {
            let date = Date()
            let formatter = DateFormatter()
            formatter.dateStyle = .long
            let currentDate = formatter.string(from: date)
            for i in weathers {
                if currentDate == i.dt?.toLongDate() {
                    let body = "Today will \(i.weather[0].description!). Everage temperature \(i.temp.eve.tempFormat())"
                    self.notifications.scheduleNotification(date: currentDate, notificationBody: body, time: UserDefaults.standard.string(forKey: "time")!)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? LocationWeatherVC {
            vc.delegate = self
        }
    }
}

extension DateWeatherVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        weathers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        cell.setBackgroundColor(icon: (weathers[indexPath.row].weather.last?.icon)!)
        cell.weatherLabel.text = weathers[indexPath.row].weather.last?.description
        cell.tempLabel.text = weathers[indexPath.row].temp.eve.tempFormat()
        DownloadService.shared.downloadImage(path: (weathers[indexPath.row].weather.last?.icon)!) { data, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.iconImageView.image = data
                }
            }
        }
        cell.titleLabel.text = weathers[indexPath.row].dt!.toLongDate()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension DateWeatherVC: LocationWeatherDelegate {
    
    func passCoordinate(longitude: Double, latitude: Double) {
        self.parameter["lon"] = longitude
        self.parameter["lat"] = latitude
        requestAPIWeather()
    }
    
}

extension UITableViewCell {
    func setBackgroundColor(icon: String) {
        switch icon {
        case "01d", "02d", "01n", "02n":
            self.backgroundColor = cellBackgroundColor.clear.color
        case "03d", "50d", "03n", "50n":
            self.backgroundColor = cellBackgroundColor.mist.color
        case "04d", "09d", "10d", "04n", "09n", "10n":
            self.backgroundColor = cellBackgroundColor.rain.color
        case "11d", "11n":
            self.backgroundColor = cellBackgroundColor.storm.color
        default:
            self.backgroundColor = .white
        }
    }
}
