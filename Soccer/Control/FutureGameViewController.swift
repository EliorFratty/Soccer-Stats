//
//  FutureGameViewController.swift
//  Soccer
//
//  Created by User on 16/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation
import LBTATools


class FutureGameViewController: UIViewController, CLLocationManagerDelegate {
    
    //MARK: - Properties

    var game: Game? = nil
    var players = [String]()
    let cellID = "playerJoinedToGame"
    
    let gameDetailesContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        //   view.layer.cornerRadius = 5
        // view.layer.masksToBounds = true
        return view
    }()
    
    let weatherContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        tb.register(PlayerJoinedToGameCell.self, forCellReuseIdentifier: cellID)
        return tb
    }()
    
    let gameTimerLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Game will start in: \n"
        lb.numberOfLines = 0
        lb.font = UIFont(name: "arial", size: 20)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 0
        
        return lb
    }()
    
    let gameLocationLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        
        return lb
    }()
    
    lazy var dismissButton : UIButton = {
        let button = UIButton()
        
        button.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitle("Return", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getPlayerComingToGame()
        startTimer()
        
        view.addSubviews(dismissButton, gameDetailesContainerView, tableView, weatherContainerView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpgameDetailesContainerViewConstraint()
        setUpTableViewConstraint()
        setupDismissConstraint()
        setUpweatherContainerViewConstraint()
        
    }
    

    //MARK: - Configurations

    func setUpweatherContainerViewConstraint() {
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
        weatherContainerView.leftAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
        weatherContainerView.topAnchor.constraint(equalTo: gameDetailesContainerView.bottomAnchor).isActive = true
        weatherContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        weatherContainerView.bottomAnchor.constraint(equalTo: dismissButton.topAnchor).isActive = true

        weatherContainerView.addSubviews(weatherCityLabel,weatherTemperatureLabel,weatherSummeryLabel, weatherImage)

        weatherCityLabel.leftAnchor.constraint(equalTo: weatherContainerView.leftAnchor).isActive = true
        weatherCityLabel.topAnchor.constraint(equalTo: weatherContainerView.topAnchor).isActive = true
        weatherCityLabel.widthAnchor.constraint(equalTo: weatherContainerView.widthAnchor, constant: -24).isActive = true
        weatherCityLabel.heightAnchor.constraint(equalTo: weatherContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        weatherTemperatureLabel.leftAnchor.constraint(equalTo: weatherContainerView.leftAnchor).isActive = true
        weatherTemperatureLabel.topAnchor.constraint(equalTo: weatherCityLabel.bottomAnchor).isActive = true
        weatherTemperatureLabel.widthAnchor.constraint(equalTo: weatherContainerView.widthAnchor, constant: -24).isActive = true
        weatherTemperatureLabel.heightAnchor.constraint(equalTo: weatherContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        weatherSummeryLabel.leftAnchor.constraint(equalTo: weatherContainerView.leftAnchor).isActive = true
        weatherSummeryLabel.topAnchor.constraint(equalTo: weatherTemperatureLabel.bottomAnchor).isActive = true
        weatherSummeryLabel.widthAnchor.constraint(equalTo: weatherContainerView.widthAnchor, constant: -24).isActive = true
        weatherSummeryLabel.heightAnchor.constraint(equalTo: weatherContainerView.heightAnchor, multiplier: 1/4).isActive = true
        
        weatherImage.leftAnchor.constraint(equalTo: weatherContainerView.leftAnchor).isActive = true
        weatherImage.topAnchor.constraint(equalTo: weatherSummeryLabel.bottomAnchor).isActive = true
        weatherImage.widthAnchor.constraint(equalTo: weatherContainerView.widthAnchor, constant: -24).isActive = true
        weatherImage.heightAnchor.constraint(equalTo: weatherContainerView.heightAnchor, multiplier: 1/4).isActive = true
    }
    
    func setUpTableViewConstraint() {
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: gameDetailesContainerView.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        tableView.bottomAnchor.constraint(equalTo: dismissButton.topAnchor).isActive = true
    }
    
    func setUpgameDetailesContainerViewConstraint() {
        gameDetailesContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        gameDetailesContainerView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        gameDetailesContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        gameDetailesContainerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        gameDetailesContainerView.addSubview(gameTimerLabel)
        
        gameTimerLabel.leftAnchor.constraint(equalTo: gameDetailesContainerView.leftAnchor, constant: 10).isActive = true
        gameTimerLabel.topAnchor.constraint(equalTo: gameDetailesContainerView.topAnchor).isActive = true
        gameTimerLabel.widthAnchor.constraint(equalTo: gameDetailesContainerView.widthAnchor).isActive = true
        gameTimerLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
 
    }
    
    func setupDismissConstraint() {
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20).isActive = true
        dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func dismissTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK:- Services
    
    func getPlayerComingToGame() {
        guard let userTeam = TeamViewController.team else {return}
        guard let userTeamName = userTeam.name else {return}
        
        guard let game = game else {return}
        
        DBService.shared.games.child(userTeamName).child(game.date).child("players").observeSingleEvent(of: .value, with: { [self](snapshot) in
            
            if let playerComingToGame = snapshot.value as? [String:Any] {
                for player in playerComingToGame{
                    self.players.append(player.key)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    var countdownTimer = Timer()

    func startTimer() {
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let releaseDateString = game!.date + " " + game!.hour

        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let date = releaseDateFormatter.date(from: releaseDateString)
        
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: date!)
        
        var countdown = "\(diffDateComponents.day ?? 0)D : \(diffDateComponents.hour ?? 0)H : \(diffDateComponents.minute ?? 0)M : \(diffDateComponents.second ?? 0)S"
        
        if let secUnderZero = diffDateComponents.second {
            if secUnderZero < 0 {
                countdown = "The game has Ended"
            }
        }
        
        gameTimerLabel.text! = "Game will start in: \n\(countdown)"
        
    }
    
    // MARK:- Weather Properties

    let locationManager = CLLocationManager()
    let geoCoder = CLGeocoder()
    
    
    let weatherInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let weatherSummeryLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textAlignment = .center
        lb.numberOfLines = 0
        
        return lb
    }()
    
    let weatherCityLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        
        return lb
    }()
    
    let weatherTemperatureLabel: UILabel = {
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
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[locations.count - 1]
        if location.horizontalAccuracy > 0 {
            
            locationManager.stopUpdatingLocation()
            
            geoCoder.reverseGeocodeLocation(location) { (placemarks, _) in
                if let placemarks = placemarks {
                    if let city = placemarks[placemarks.count-1].locality {
                        self.weatherCityLabel.text = city
                    }
                }
            }
            
            WeatherJSON.forecast(withLocation: location.coordinate) { [self] (results:[WeatherJSON]?) in
                
                DispatchQueue.main.async {
                    if let weatherData = results {
                        
                        let weatherGameDate = self.searchGameDateInJsonWeather(results: weatherData)

                        if let weatherInfo = weatherGameDate{
                            self.weatherSummeryLabel.text = weatherInfo.summary
                            self.weatherTemperatureLabel.text = "\(Int((weatherInfo.minTemperature - 32) * 5/9)) - \(Int((weatherInfo.maxTemperature - 32) * 5/9)) C"
                            self.weatherImage.image = UIImage(named: weatherInfo.icon)
                        } else {
                             self.weatherSummeryLabel.text = "No information on this date... try again in few days"
                        }
                    }
                }
            }
        }
    }
    
    func searchGameDateInJsonWeather(results weatherData:[WeatherJSON]) -> WeatherJSON?{

        for weather in weatherData {
            let myDate = Date(timeIntervalSince1970: weather.time).toString(dateFormat: "dd-MM-yyyy")
            if myDate == self.game!.date {
                return weather
            }
        }
        return nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        weatherCityLabel.text = "Location Unavailable"
    }
}

// MARK: - TableView functions

extension FutureGameViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) 
        cell.textLabel?.text = players[indexPath.row]
        return cell
    }
}
