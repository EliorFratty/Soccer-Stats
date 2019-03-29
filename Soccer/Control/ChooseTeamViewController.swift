//
//  ChooseTeamViewController.swift
//  
//
//  Created by User on 08/03/2019.
//

import UIKit
import Firebase

class ChooseTeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var teams = [String]()
    var searchedTeam = [String]()
    var teamClicked = ""
    var checkIfThisTeamExsist = false
    var searching = false
    
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var activityIndic: UIActivityIndicatorView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Auth.auth().currentUser?.uid == nil {
            let viewCntroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            self.present(viewCntroller, animated: true, completion: nil)
        }

        reciveTeamsFromDB()
        makeNavBar()
        tblView.allowsMultipleSelectionDuringEditing = true
        tblView.rowHeight = UITableView.automaticDimension

    }
    
    // MARK: - service

    func reciveTeamsFromDB() {
        var teamsFromDB = [String]()
        
        DBService.shared.playerInTeamRef.observe(.value) { (snapshot) in
            self.activityIndic.stopAnimating()
            guard let snapDict = snapshot.value as? [String: [String : Any]] else {return}
            teamsFromDB.removeAll()
            for team in snapDict.keys{
                teamsFromDB.append(team)
            }

            self.teams = teamsFromDB
            self.tblView.reloadData()
        }
    }

    
    @objc func logoutTapped(){

       try! Auth.auth().signOut()
        
        let viewCntroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        self.present(viewCntroller, animated: true, completion: nil)
        
    }
        

    
    
    // MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searching {
           return searchedTeam.count
        } else {
            return teams.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! ChooseTeamTableViewCell

        if searching {
            cell.teamNameLabel.text = searchedTeam[indexPath.row]
        } else {
            cell.teamNameLabel.text = teams[indexPath.row]
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if searching {
            let teamToRemove = searchedTeam[indexPath.row]
            self.searchedTeam.remove(at: indexPath.row)
            
            self.tblView.deleteRows(at: [indexPath], with: .automatic )
            
            deleteTeamFromTeams(teamToDelete: teamToRemove)
            DBService.shared.playerInTeamRef.child(teamToRemove).removeValue { (error, ref) in}
            
        } else {
            let teamToRemove = teams[indexPath.row]

            self.teams.remove(at: indexPath.row)
            
            self.tblView.deleteRows(at: [indexPath], with: .automatic )
            
            DBService.shared.playerInTeamRef.child(teamToRemove).removeValue { (error, ref) in}
        }
        
    }
    
    func deleteTeamFromTeams(teamToDelete: String) {
        
        teams = teams.filter({$0 != teamToDelete})
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if searching {
            teamClicked = searchedTeam[indexPath.row]
        } else {
            teamClicked = teams[indexPath.row]
        }
        
        self.performSegue(withIdentifier: "showTeam", sender: self)

    }
    
    
    // MARK: - NAV & SEARCH bar
    
    func makeNavBar() {
        let logoutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logoutTapped))
        
        self.navigationItem.rightBarButtonItem = logoutButton
        
        let user = Auth.auth().currentUser
        if let user = user, let email = user.email {
            self.navigationItem.title = "⚽️ Hello \(email) ⚽️"
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedTeam = teams.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        self.searching = true
        tblView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblView.reloadData()
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send array of all teams in DB
        if let addTeamVC = segue.destination as? AddTeamViewController {
            addTeamVC.teams = teams
        } else if let _ = segue.destination as? TeamViewController {
            TeamViewController.team = teamClicked
        }
    }

}

class ChooseTeamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
}
