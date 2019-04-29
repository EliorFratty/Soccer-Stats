//
//  PreviousGameViewController.swift
//  Soccer
//
//  Created by User on 16/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class PreviousGameViewController: UIViewController {
    
    // MARK:- Propreties
    
    var games = [Game]()
    let cellID = "prevGameCell"
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.backgroundColor = .black
        tb.register(PlayerJoinedToGameCell.self, forCellReuseIdentifier: cellID)
        return tb
    }()

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
    // MARK:- Lifecycle


    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dismissButton)
        setupDismissConstraint()


    }
    // MARK:- Handlers

    func setupDismissConstraint() {
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func dismissTapped(){
        self.dismiss(animated: true, completion: nil)
    }
    
    func getAllGamesFromDB() {
        guard let userTeam = TeamViewController.team else {return}
        guard let userTeamName = userTeam.name else {return}
        
        DBService.shared.games.child(userTeamName).observeSingleEvent(of: .value) { [self] (snapshot) in
            if let teamGames = snapshot.value as? [String:[String:Any]] {
                
                let releaseDateFormatter = DateFormatter()
                releaseDateFormatter.dateFormat = "dd-MM-yyyy"
                
                for games in teamGames {
                    let date = games.key
                    let hour = games.value["hour"] as! String
                    let location = games.value["location"] as! String
                    
                    let gameDate = releaseDateFormatter.date(from: date)
                    
                    if gameDate!.compare(Date()) == .orderedAscending {
                        let game = Game(date:date, hour: hour, place: location, isComing: false)
                        self.games.append(game)
                    }
                }
                
                self.games.sort(by: { (game1, game2) -> Bool in
                    
                    
                    let date1 = releaseDateFormatter.date(from: game1.date)
                    let date2 = releaseDateFormatter.date(from: game2.date)
                    return date1?.compare(date2!) == .orderedAscending
                    
                })
                self.tableView.reloadData()
            }
        }
    }
}
