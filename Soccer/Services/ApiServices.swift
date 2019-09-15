//
//  ApiServices.swift
//  Soccer
//
//  Created by User on 02/09/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation
import CoreLocation

struct ApiServices {
    
    static let shared = ApiServices()
    
    private init() {}
    
    
    func getWeatherFromDarkSkyApi(withLocation location: CLLocationCoordinate2D, completion: @escaping ([WeatherJSON]) -> ()) {
        
        let urlForWeather = "https://api.darksky.net/forecast/08662dac643c2515cf324be0bfdd81ec/"
        let url = urlForWeather + "\(location.latitude),\(location.longitude)"
        let request = URLRequest(url: URL(string: url)!)
        
        let task = URLSession.shared.dataTask(with: request) { (data:Data?, response: URLResponse?, error: Error?) in
            var forcastArray: [WeatherJSON] = []
            
            if let data = data {
                do {
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                        if let dailyForcasts = json["daily"] as? [String:Any] {
                            if let dailyData = dailyForcasts["data"] as? [[String:Any]] {
                                for dataPoint in dailyData {
                                    if let weatherObject = try? WeatherJSON(json: dataPoint) {
                                        forcastArray.append(weatherObject)
                                    }
                                }
                            }
                        }
                    }
                }catch {
                    print(error.localizedDescription)
                }
                completion(forcastArray)
            }
            
        }
        task.resume()
    }
}
