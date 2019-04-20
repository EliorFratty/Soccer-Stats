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
    
    lazy var dismissButton : UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor.red
        
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitle("Return", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        return button
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let summeryLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0

        return lb
    }()
    
    let cityLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
      
        return lb
    }()
    
    let temperatureLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textAlignment = .center

        return lb
    }()
    
    let weatherImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit

        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        view.addSubview(inputContainerView)
        view.addSubview(dismissButton)
        
        setupinputContainerViewConstraint()
        setupDismissConstraint()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func setupDismissConstraint() {
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        dismissButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        dismissButton.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/5).isActive = true
    }
    
    func setupinputContainerViewConstraint(){
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 400).isActive = true
        
        inputContainerView.addSubview(cityLabel)
        inputContainerView.addSubview(temperatureLabel)
        inputContainerView.addSubview(summeryLabel)
        inputContainerView.addSubview(weatherImage)

        cityLabel.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        cityLabel.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        cityLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        cityLabel.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        temperatureLabel.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        temperatureLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor).isActive = true
        temperatureLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        temperatureLabel.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        summeryLabel.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        summeryLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor).isActive = true
        summeryLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        summeryLabel.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        weatherImage.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        weatherImage.topAnchor.constraint(equalTo: summeryLabel.bottomAnchor).isActive = true
        weatherImage.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        weatherImage.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
    }
    
    @objc func dismissTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
        
            self.locationManager.stopUpdatingLocation()
                        
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
                            self.summeryLabel.text = weatherInfo.summary
                            self.temperatureLabel.text = "\(Int((weatherInfo.temperature - 32) * 5/9)) C"
                            self.weatherImage.image = UIImage(named: weatherInfo.icon)
                        }
                    }
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Location Unavailable"
    }
}
