//
//  DownloadImage.swift
//  Weather App
//
//  Created by Duy Dinh on 11/2/20.
//

import UIKit

struct DownloadService {
    static var shared = DownloadService()
    
    private var cache: NSCache<NSString, UIImage> = NSCache<NSString, UIImage>()
    
    func downloadImage(path: String, completion: @escaping (UIImage?, Error?) -> Void) {
        guard let url = URL(string: ("https://openweathermap.org/img/wn/\(path)@2x.png")) else { return }
        
        if let image = cache.object(forKey: NSString(string: url.absoluteString)) {
            completion(image, nil)
        } else {
            URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completion(nil, error)
                    return
                }
                let image = UIImage(data: data)!
                cache.setObject(image, forKey: NSString(string: url.absoluteString))
                completion(UIImage(data: data), nil)
            }.resume()
        }
    }
}
