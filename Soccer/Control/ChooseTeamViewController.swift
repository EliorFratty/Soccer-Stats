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
        allTeams.removeAll()
        tblView.reloadData()
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            
            let viewCntroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            self.present(viewCntroller, animated: true, completion: nil)
            
        } else {
            
            uid = Auth.auth().currentUser?.uid
            
            DBService.shared.users.child(uid!).observe(.value) { [self] (snapshot) in
                if let dict = snapshot.value as? [String:Any] {

                    if let name = dict["fullName"] as? String,
                       let email = dict["email"] as? String,
                       let profileImageUrl = dict["profileImageUrl"] as? String{
                        TeamViewController.player = Player(fullName: name, email:email, profileImageUrl:profileImageUrl)
                        
                        self.navigationItem.title = "Hello \(name)"
                    }
                } else {
                     TeamViewController.player = Player(fullName: "ploni almoni", email:"ploniAlmoni@gamel.com", profileImageUrl:"profileImageUrl")
                }
                
                self.reciveTeamsFromDB()
            }
        }
    }
    
    // MARK: - service

    func reciveTeamsFromDB() {

        guard let uid = Auth.auth().currentUser?.uid else {print("Error") ; return }
        
        if allTeams.isEmpty {
            self.activityIndic.stopAnimating()
        }
        
        allTeams.removeAll()
        DBService.shared.users.child(uid).child("teams").observe(.childAdded) { [self] (snapshot) in
            self.activityIndic.stopAnimating()

            guard let snapDict = snapshot.value as? [String : Any] else {return}

            let team = Team()
            team.name = snapDict["name"] as? String
            team.date = snapDict["date"] as? String
            team.teamImoji = snapDict["imoji"] as? String ?? "⚽️"
            
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! chooseTeamCell
        
        var myTeam = Team()

        if searching {
             myTeam = searchedTeam[indexPath.row]
        } else {
             myTeam = allTeams[indexPath.row]
        }

            cell.titleLabel.text = myTeam.name
            cell.subTitleLabel.text = myTeam.date
            cell.imojiLabel.text = myTeam.teamImoji

        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let teamToRemove: String

        if searching {
            
            teamToRemove = searchedTeam[indexPath.row].name!
            deleteTeamFromTeams(teamToDelete: teamToRemove)
            
        } else {
            
             teamToRemove = allTeams[indexPath.row].name!
            
        }
        
        self.searchedTeam.remove(at: indexPath.row)
        self.tblView.deleteRows(at: [indexPath], with: .automatic )
        
        DBService.shared.users.child(uid!).child("teams").child(teamToRemove).removeValue { (error, ref) in}
  
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send array of all teams in DB
        if let addTeamVC = segue.destination as? AddTeamViewController {
            addTeamVC.teams = allTeams
            addTeamVC.uid = uid
        } else if let _ = segue.destination as? TeamViewController {
            TeamViewController.team = teamClicked
        }
    }

    @IBAction func logoutTapped(_ sender: Any) {
        try! Auth.auth().signOut()
        
        let viewCntroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        self.present(viewCntroller, animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
        
    }
    
}

class chooseTeamCell: UITableViewCell {
    
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imojiLabel: UILabel!
}
