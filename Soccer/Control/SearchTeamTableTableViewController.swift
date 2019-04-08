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
        tableView.register(ChooseTeamCell.self, forCellReuseIdentifier: cellID)

    }
    
    func makeNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTeamToDB))

    }
    
    @objc func cancelTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addTeamToDB(){
        let addTeamViewController = AddTeamViewController()
        navigationController?.pushViewController(addTeamViewController, animated: true)
    }
    
    func reciveTeamsFromDB() {

        DBService.shared.allTeams.observe(.childAdded) { [self] (snapshot) in
            guard let snapDict = snapshot.value as? [String : Any] else {return}
            
            let team = Team()
            team.name = snapDict["name"] as? String
            team.date = snapDict["date"] as? String
            team.teamImoji = snapDict["imoji"] as? String ?? "⚽️"
            
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
       
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ChooseTeamCell
        
        cell.team = allTeam[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = Auth.auth().currentUser?.uid
        
        let teamParam = ["team": allTeam[indexPath.row].name]
        
        if let uid = uid, let newTeam =  allTeam[indexPath.row].name{
            DBService.shared.users.child(uid).child("teams").child(newTeam).setValue(teamParam) { (eror, ref) in
                print("**")
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
}
