//
//  Request.swift
//  Weather
//
//  Created by Duy Dinh on 10/27/20.
//

import Foundation

struct requestApi {

    func request(parameter: [String: Any], headers: [String: String]?, completion: @escaping ([Daily]?, Error?) -> Void) {
        var components = URLComponents(string: Domain.dailyForecast7DaysUrl)
        components?.queryItems = parameter.map {
            URLQueryItem(name: $0.key, value: String(describing: $0.value))
        }
        
        var request = URLRequest(url: (components?.url)!)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        print(request)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil, error)
                return
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let dataObject = try? decoder.decode(APIResponse.self, from: data) {
                completion(dataObject.daily, nil)
            }
        }.resume()
    }
    
}

