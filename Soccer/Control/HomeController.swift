//
//  HomeController.swift
//  Soccer
//
//  Created by User on 08/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class HomeController: UIViewController {
    
    //MARK: - Properties
    
    var delegate: HomeControllerDelegate?
    var searchedTeam = [Team]()
    var allTeams = [Team]()
    var teamClicked = ""
    var searching = false
    var uid: String?
    let cellID = "myTeamCell"
    
    var tableView: UITableView!
    
    let activityIndic: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.startAnimating()
        
        return ai
    }()
    
    var searchBar: UISearchBar!
    
    
    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configurateNavigationBar()
        configurateSearchBar()
        configurateTableView()
        checkIfUserIsLoggedIn()
    }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            getUserLoggedIn()
            reciveTeamsFromDB()
            tableView.reloadData()

        }
    
 
    
    // MARK: - service
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            let viewCntroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
            self.present(viewCntroller, animated: true, completion: nil)
        }
    }
    
    func getUserLoggedIn(){
        guard let uid = Auth.auth().currentUser?.uid else {print("Error") ; return }
        DBService.shared.users.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            if let dict = snapshot.value as? [String:Any] {
                let name = dict["fullName"] as! String
                self.navigationItem.title = "Hello \(name)"
            }
        }
    }
    
    func reciveTeamsFromDB() {
        guard let uid = Auth.auth().currentUser?.uid else {print("Error") ; return }
        allTeams.removeAll()
        DBService.shared.users.child(uid).child("teams").observe(.childAdded) { [self] (snapshot) in
            self.activityIndic.stopAnimating()
            
            guard let snapDict = snapshot.value as? [String : Any] else {return}
            
            let teamName = snapDict["team"] as? String

            DBService.shared.allTeams.child(teamName!).observe(.value, with: { (snapshot) in
                guard let snapDict = snapshot.value as? [String : Any] else {return}
                
                let team = Team()
                team.name = snapDict["name"] as? String
                team.date = snapDict["date"] as? String
                team.teamImoji = snapDict["imoji"] as? String ?? "A"
                
                self.allTeams.append(team)
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            })
        }
    }

    //MARK: - Configurations
    
    func configurateTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(ChooseTeamCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .darkGray
        tableView.keyboardDismissMode = .onDrag
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 300
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.addSubview(activityIndic)
        activityIndic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndic.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndic.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndic.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func configurateSearchBar() {
        searchBar = UISearchBar()
        searchBar.delegate = self
        
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        
        //x,y,width,height
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive =  true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func configurateNavigationBar() {
        navigationController?.navigationBar.barTintColor = .green
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let addTeamButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(handleMenuToggle))
        self.navigationItem.leftBarButtonItem = addTeamButton
        
        let searchTeamButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchTeamFromAllUsers))
        self.navigationItem.rightBarButtonItem = searchTeamButton
        
        
    }
    //MARK: - Handlers

    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //send array of all teams in DB
        if let addTeamVC = segue.destination as? AddTeamViewController {
            addTeamVC.teams = allTeams
            addTeamVC.uid = uid
        } else if let _ = segue.destination as? TeamViewController {
            TeamViewController.team = teamClicked
        }
    }
}

// MARK: - TAbleView Functions

extension HomeController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedTeam.count
        } else {
            return allTeams.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ChooseTeamCell
        
        var myTeam = Team()
        
        if searching {
            myTeam = searchedTeam[indexPath.row]
        } else {
            myTeam = allTeams[indexPath.row]
        }
        
        cell.team = myTeam
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let teamToRemove: String
        uid = Auth.auth().currentUser?.uid
        
        if searching {
            
            teamToRemove = searchedTeam[indexPath.row].name!
            deleteTeamFromTeams(teamToDelete: teamToRemove)
            searchedTeam.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic )

            
        } else {
            teamToRemove = allTeams[indexPath.row].name!
            allTeams.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic )
        }

        DBService.shared.users.child(uid!).child("teams").child(teamToRemove).removeValue { (error, ref) in
            //self.reciveTeamsFromDB(uid: self.uid!)
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
        
        TeamViewController.team = teamClicked
        
        let teamViewController = TeamViewController()
        navigationController?.pushViewController(teamViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}


// MARK: - Search Bar Functions

extension HomeController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedTeam = allTeams.filter({$0.name!.lowercased().prefix(searchText.count) == searchText.lowercased()})
        self.searching = true
        tableView.reloadData()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    
    @objc func searchTeamFromAllUsers(){
    
        let searchTeamTableTableViewController = SearchTeamTableTableViewController()
        let navController = UINavigationController(rootViewController: searchTeamTableTableViewController)
        present(navController, animated: true, completion: nil)
    }
    
    
}
