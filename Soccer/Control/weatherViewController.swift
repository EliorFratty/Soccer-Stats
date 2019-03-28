//
//  weatherViewController.swift
//  Soccer
//
//  Created by User on 24/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import CoreLocation
import ContactsUI
import Contacts

class weatherViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    var forcastData = [WeatherJSON]()

    @IBOutlet weak var summeryTextField: UITextView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
        
            self.locationManager.stopUpdatingLocation()
            
            //print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            geoCoder.reverseGeocodeLocation(location) { (placemarks, _) in
                if let placemarks = placemarks {
                    if let city = placemarks[placemarks.count-1].locality {
                        self.cityLabel.text = city
                    }
                }
            }
            
                 WeatherJSON.forecast(withLocation: location.coordinate) { (results:[WeatherJSON]?) in
                    
                    DispatchQueue.main.async {
                          if let weatherData = results {
                            if let weatherInfo = weatherData.first {
                                self.summeryTextField.text = weatherInfo.summary
                                self.temperatureLabel.text = "\(Int((weatherInfo.temperature - 32) * 5/9)) C"
                                self.weatherImage.image = UIImage(named: weatherInfo.icon)
                            }

                            //self.cityLabel.text = self.forcastData.first?.summary
                        }
                    }
                  
                }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailable"
    }
    
    
    
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    
    
    
}
