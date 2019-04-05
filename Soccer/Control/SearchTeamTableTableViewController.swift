//
//  SearchTeamTableTableViewController.swift
//  Soccer
//
//  Created by User on 30/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase


class SearchTeamTableTableViewController: UITableViewController {

    var allTeam = [Team]()
    let cellID = "theSearchCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeNavBar()
        reciveTeamsFromDB()
        tableView.register(teamCell.self, forCellReuseIdentifier: cellID)

    }
    
    func makeNavBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
    }
    
    @objc func cancelTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    func reciveTeamsFromDB() {

        DBService.shared.allTeams.observe(.childAdded) { [self] (snapshot) in
            guard let snapDict = snapshot.value as? [String : Any] else {return}
            
            let team = Team()
            team.name = snapDict["name"] as? String
            team.date = snapDict["date"] as? String
            
            self.allTeam.append(team)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
            return allTeam.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        cell.textLabel?.text = allTeam[indexPath.row].name
        cell.detailTextLabel?.text = allTeam[indexPath.row].date
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = Auth.auth().currentUser?.uid
        
        let teamParam = [
            "name": allTeam[indexPath.row].name,
            "date" : allTeam[indexPath.row].date
        ]
        
        if let uid = uid, let newTeam =  allTeam[indexPath.row].name{
            DBService.shared.users.child(uid).child("teams").child(newTeam).setValue(teamParam)
        }
        dismiss(animated: true, completion: nil)
    }
}

class teamCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
