//
//  WeatherPopUpView.swift
//  Soccer
//
//  Created by User on 12/09/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherPopUpView: UIView, CLLocationManagerDelegate {
  
    let containerWidth =  UIScreen.main.bounds.width * 0.75
    let containerHeight = UIScreen.main.bounds.height * 0.45
    
    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    var forcastData = [WeatherJSON]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
       
        setupAnchors()
        setupTapGestureRecognizer()

        animateIn()
    }

    fileprivate let container: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        return v
    }()
    
    func setupAnchors(){
        self.addSubview(container)
        container.centerInSuperview(size: CGSize(width: containerWidth, height: containerHeight))
        container.addSubviews(backGroundImage, weatherIconImge, tempLabel, cityLabel)
        
        backGroundImage.centerInSuperview(size: CGSize(width: containerWidth, height: containerHeight))
        
        let weatherImageWidth: CGFloat = containerWidth - 40
        weatherIconImge.anchor(top: nil, leading: container.leadingAnchor, bottom: container.bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 20, bottom: 20, right: 20), size: CGSize(width: weatherImageWidth, height: 180))
        
        tempLabel.anchor(top: nil, leading: nil, bottom: weatherIconImge.topAnchor, trailing: weatherIconImge.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 5, right: 0), size: CGSize(width: 140, height: 50))
        
        cityLabel.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 50, bottom: 0, right: 0), size: CGSize(width: containerWidth, height: 50))
    }
    
    let tempLabel: UILabel = {
       let lbl = UILabel()
        lbl.font = UIFont.boldSystemFont(ofSize: 60)
        lbl.textColor = .white
        
        return lbl
    }()
    
    let cityLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "Arial", size: 40)
        lbl.textAlignment = .center
        lbl.textColor = .white
        
        return lbl
    }()
    
    let weatherIconImge: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let backGroundImage: UIImageView = {
       let imageView = UIImageView(image: #imageLiteral(resourceName: "weatherBackGround"))
        
        return imageView
    }()
    
    @objc fileprivate func animateOut() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: +self.frame.height)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc fileprivate func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: +self.frame.height)
        self.alpha = 1
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

            ApiServices.shared.getWeatherFromDarkSkyApi(withLocation: location.coordinate) { (jsonWeather) in
                DispatchQueue.main.async {
                        if let weatherInfo = jsonWeather.first {
                            //self.summeryLabel.text = weatherInfo.summary
                            self.tempLabel.text = "\(Int((weatherInfo.maxTemperature - 32) * 5/9))°"//
                            self.weatherIconImge.image = UIImage(named: weatherInfo.icon)
                    }
                }
            }
        }
    }
}


extension WeatherPopUpView: UIGestureRecognizerDelegate {
    
    func setupTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(animateOut))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == container {
            return false
        }
        return true
    }
}
