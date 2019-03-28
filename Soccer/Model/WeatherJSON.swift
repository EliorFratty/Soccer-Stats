//
//  Weather.swift
//  Soccer
//
//  Created by User on 24/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation
import CoreLocation

struct WeatherJSON {
    let summary: String
    let icon: String
    let temperature: Double
    
    enum  SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws{
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        
        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temperature is missing")}
        
        self.summary = summary
        self.icon = icon
        self.temperature = temperature
        
    }
    
    static let urlForWeather = "https://api.darksky.net/forecast/08662dac643c2515cf324be0bfdd81ec/"

    static func forecast (withLocation location: CLLocationCoordinate2D, completion: @escaping ([WeatherJSON]) -> ()) {
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


