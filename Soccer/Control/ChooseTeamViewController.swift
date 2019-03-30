//
//  ChooseTeamViewController.swift
//  
//
//  Created by User on 08/03/2019.
//

import UIKit
import Firebase

class ChooseTeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var searchedTeam = [Team]()
    var teamClicked = ""
    var checkIfThisTeamExsist = false
    var searching = false
    var uid: String?
    var allTeams = [Team]()
    
    
    @IBOutlet weak var tblView: UITableView!
    
    @IBOutlet weak var activityIndic: UIActivityIndicatorView!
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavBar()
        tblView.allowsMultipleSelectionDuringEditing = true
        tblView.rowHeight = UITableView.automaticDimension

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkIfUserIsLoggedIn()
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            let viewCntroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            self.present(viewCntroller, animated: true, completion: nil)
        } else {
            uid = Auth.auth().currentUser?.uid
            DBService.shared.users.child(uid!).observeSingleEvent(of: .value) { (snapshot) in
                if let dict = snapshot.value as? [String:Any] {
                    if let name = dict["Name"] as? String {
                    self.navigationItem.title = "Hello \(name)"
                    }
                }
            }
            reciveTeamsFromDB()
        }
    }
    
    // MARK: - service

    func reciveTeamsFromDB() {

        guard let uid = Auth.auth().currentUser?.uid else {print("Error") ; return }
        
        allTeams.removeAll()
        DBService.shared.users.child(uid).child("teams").observe(.childAdded) { [self] (snapshot) in
            self.activityIndic.stopAnimating()

            guard let snapDict = snapshot.value as? [String : Any] else {return}

            let team = Team()
            team.name = snapDict["name"] as? String
            team.date = snapDict["date"] as? String
            
            self.allTeams.append(team)
            
            DispatchQueue.main.async {
                self.tblView.reloadData()
            }
        }
    }
        

    // MARK: - tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if searching {
           return searchedTeam.count
        } else {
            return allTeams.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! ChooseTeamTableViewCell

        if searching {
            cell.teamNameLabel.text = searchedTeam[indexPath.row].name
        } else {
            cell.teamNameLabel.text = allTeams[indexPath.row].name
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if searching {
            let teamToRemove = searchedTeam[indexPath.row].name!
            self.searchedTeam.remove(at: indexPath.row)
            
            self.tblView.deleteRows(at: [indexPath], with: .automatic )
            
            deleteTeamFromTeams(teamToDelete: teamToRemove)
            DBService.shared.users.child(uid!).child("teams").child(teamToRemove).removeValue { (error, ref) in}
            
        } else {
            let teamToRemove = allTeams[indexPath.row].name!

            self.allTeams.remove(at: indexPath.row)
            
            self.tblView.deleteRows(at: [indexPath], with: .automatic )
            
             DBService.shared.users.child(uid!).child("teams").child(teamToRemove).removeValue { (error, ref) in}
        }
        
    }
    
    func deleteTeamFromTeams(teamToDelete: String) {
        
        allTeams = allTeams.filter({$0.name! != teamToDelete})
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if searching {
            teamClicked = searchedTeam[indexPath.row].name!
        } else {
            teamClicked = allTeams[indexPath.row].name!
        }
        
        self.performSegue(withIdentifier: "showTeam", sender: self)

    }
    
    
    // MARK: - NAV & SEARCH bar
    
    func makeNavBar() {
        let addTeamButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addTeamToUser))
        self.navigationItem.rightBarButtonItem = addTeamButton
        
        let searchTeamButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchTeamFromAllUsers))
        self.navigationItem.leftBarButtonItem = searchTeamButton
    
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedTeam = allTeams.filter({$0.name!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        self.searching = true
        tblView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tblView.reloadData()
    }
    
    @objc func addTeamToUser(){
        
        performSegue(withIdentifier: "createNewTeam", sender: self)
    
    }
    
    @objc func searchTeamFromAllUsers(){
        let searchTeamTableTableViewController = SearchTeamTableTableViewController()
        let navController = UINavigationController(rootViewController: searchTeamTableTableViewController)
        present(navController, animated: true, completion: nil)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send array of all teams in DB
        if let addTeamVC = segue.destination as? AddTeamViewController {
             let uid = Auth.auth().currentUser?.uid
            addTeamVC.teams = allTeams
            addTeamVC.uid = uid
        } else if let _ = segue.destination as? TeamViewController {
            TeamViewController.team = teamClicked
        }
    }

}

class ChooseTeamTableViewCell: UITableViewCell {
    
    @IBOutlet weak var teamNameLabel: UILabel!
    
}
