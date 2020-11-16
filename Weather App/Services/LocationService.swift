//
//  LocationService.swift
//  Weather App
//
//  Created by Duy Dinh on 11/4/20.
//

import UIKit

struct LocationService {

    func locationRequest(parameter: [String: Any], headers: [String: String]?, completion: @escaping (Location?, Error?) -> Void) {
        var components = URLComponents(string: Domain.currentDataUrl)
        components?.queryItems = parameter.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        var request = URLRequest(url: (components?.url)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let dataObject = try? decoder.decode(Location.self, from: data)
            completion(dataObject, nil)
        }.resume()
    }
    
    func allData() -> [Location] {
        var array: [Location] = []
        let locations = ["Da Nang", "Ha Noi", "Ho Chi Minh City"]
        for location in locations {
            let parameter: [String: Any] = ["q": location, "appid": Domain.appid, "units": "metric"]
            LocationService().locationRequest(parameter: parameter, headers: Domain.headers) { data, error in
                guard let data = data, error == nil else { return }
                array.append(data)
            }
        }
        return array
    }
}
