//
//  LocationManager.swift
//  Weather App
//
//  Created by Duy Dinh on 11/4/20.
//

import UIKit
import CoreLocation

typealias LocationCompletion = (CLLocation) -> ()

class LocationManager: NSObject {
    static var shared = LocationManager()
    
    var location: CLLocation?
    var currentCompletion: LocationCompletion?
    let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func startUpdating(completion: @escaping LocationCompletion) {
        currentCompletion = completion
        locationManager.startUpdatingLocation()
    }
    func stopUpdating() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.last
        currentCompletion?(self.location ?? CLLocation())
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        
    }
}

