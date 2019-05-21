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
        tb.register(PlayerJoinedToGameCell.self, forCellReuseIdentifier: cellID)
        return tb
    }()

    lazy var dismissButton : UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor.red
        
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitle("Return", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubviews(dismissButton,tableView)
        setupDismissButtonConstraint()
        setupTableViewConstraint()
        getAllGamesFromDB()

    }

    //MARK: - Configurations

    func setupTableViewConstraint() {
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: dismissButton.topAnchor, trailing: view.trailingAnchor)
        
    }

    func setupDismissButtonConstraint() {
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        dismissButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func dismissTapped(){
        self.dismiss(animated: true, completion: nil)
    }

    // MARK: - Service
    
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

// MARK:- TableView functions

extension PreviousGameViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.text = "  Previous Games:"

        return label
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)

        cell.textLabel?.text = games[indexPath.row].date
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

    }
}
