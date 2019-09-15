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
    let maxTemperature: Double
    let minTemperature: Double
    let time: Double
    
    enum  SerializationError:Error {
        case missing(String)
        case invalid(String, Any)
    }
    
    init(json:[String:Any]) throws{
        guard let summary = json["summary"] as? String else {throw SerializationError.missing("summary is missing")}
        
        guard let icon = json["icon"] as? String else {throw SerializationError.missing("icon is missing")}
        
        guard let temperature = json["temperatureMax"] as? Double else {throw SerializationError.missing("temperature is missing")}
        
        guard let minTemperature = json["temperatureMin"] as? Double else {throw SerializationError.missing("temperature is missing")}

        guard let time = json["time"] as? Double else {throw SerializationError.missing("time is missing")}

        self.summary = summary
        self.icon = icon
        self.maxTemperature = temperature
        self.time = time
        self.minTemperature = minTemperature
        
    }
 }


