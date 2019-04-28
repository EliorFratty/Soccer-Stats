//
//  FutureGameViewController.swift
//  Soccer
//
//  Created by User on 16/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class FutureGameViewController: UIViewController {
    
    // MARK:- Propreties
    
    var game: Game? = nil
    var players = [String]()
    let cellID = "playerJoinedToGame"
    
    let gameDetailesContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
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
        tb.backgroundColor = .black
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
        
        button.backgroundColor = UIColor.red
        
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
        
        view.addSubview(dismissButton)
        view.addSubview(gameDetailesContainerView)
        view.addSubview(tableView)
        view.addSubview(weatherContainerView)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        setUpgameDetailesContainerViewConstraint()
        setUpTableViewConstraint()
        setupDismissConstraint()
        setUpweatherContainerViewConstraint()
        
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
    
    
    // MARK:- Handlers
    
    func setUpweatherContainerViewConstraint() {
        weatherContainerView.leftAnchor.constraint(equalTo: tableView.rightAnchor).isActive = true
        weatherContainerView.topAnchor.constraint(equalTo: gameDetailesContainerView.bottomAnchor).isActive = true
        weatherContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2).isActive = true
        weatherContainerView.bottomAnchor.constraint(equalTo: dismissButton.topAnchor).isActive = true
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
        gameDetailesContainerView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        gameDetailesContainerView.addSubview(gameTimerLabel)
        
        gameTimerLabel.leftAnchor.constraint(equalTo: gameDetailesContainerView.leftAnchor, constant: 10).isActive = true
        gameTimerLabel.topAnchor.constraint(equalTo: gameDetailesContainerView.topAnchor).isActive = true
        gameTimerLabel.widthAnchor.constraint(equalTo: gameDetailesContainerView.widthAnchor).isActive = true
        gameTimerLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        
    }
    
    func setupDismissConstraint() {
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func dismissTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    var releaseDate: NSDate?
    var countdownTimer = Timer()
    
    func startTimer() {
        
        let releaseDateString = "04-23-2019 20:44"
        let releaseDateFormatter = DateFormatter()
        releaseDateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
        releaseDate = releaseDateFormatter.date(from: releaseDateString)! as NSDate
        
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        let currentDate = Date()
        let calendar = Calendar.current
        
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second], from: currentDate, to: releaseDate! as Date)
        
        var countdown = "\(diffDateComponents.day ?? 0)D : \(diffDateComponents.hour ?? 0)H : \(diffDateComponents.minute ?? 0)M : \(diffDateComponents.second ?? 0)S"
        
        if let secUnderZero = diffDateComponents.second {
            if secUnderZero < 0 {
                countdown = "The game has Ended"
            }
        }
        
        gameTimerLabel.text! = "Game will start in: \n\(countdown)"
        
    }
}

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
