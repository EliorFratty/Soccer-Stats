//
//  SearchTeamTableTableViewController.swift
//  Soccer
//
//  Created by User on 30/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase


class SearchTeamTableTableViewController: UIViewController{
    
    //MARK: - Properties

    var allTeams = [Team]()
    let cellID = "theSearchCell"
    var searchedTeam = [Team]()
    var searching = false
    
    private let textDesign = TextDesign()
    
    lazy var searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        sb.barTintColor = textDesign.navigationBarTintColor

        return sb
    }()
    
    lazy var tableView: UITableView = {
       let tb = UITableView()
        tb.register(ChooseTeamCell.self, forCellReuseIdentifier: cellID)
        tb.keyboardDismissMode = .onDrag
        
        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubviews(searchBar, tableView)
        
        reciveTeamsFromDB()
        makeNavBar()
        configurateSearchBar()
        configurateTableView()
    }
    
    //MARK: - Configurations
    
    func configurateSearchBar() {
        
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive =  true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func configurateTableView() {
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func makeNavBar() {
        navigationController?.navigationBar.barTintColor = textDesign.navigationBarTintColor
        navigationController?.navigationBar.barStyle = .blackTranslucent
        self.title = "Search Team"
        
        let cancelButton =  UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        cancelButton.setTitleTextAttributes(textDesign.navigationBarButtonItemAtrr, for: .normal)
        navigationItem.leftBarButtonItem = cancelButton
        
        let addNewTeamButton = UIBarButtonItem(title: "New Team", style: .plain, target: self, action: #selector(addTeamToDB))
        addNewTeamButton.setTitleTextAttributes(textDesign.navigationBarButtonItemAtrr, for: .normal)
        navigationItem.rightBarButtonItem = addNewTeamButton
        
    }

    //MARK: - Handlers

    @objc func cancelTapped(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func addTeamToDB(){
        let addTeamViewController = AddNewTeamViewController()
        navigationController?.pushViewController(addTeamViewController, animated: true)
    }

    // MARK: - Servies
    
    func reciveTeamsFromDB() {

        DBService.shared.allTeams.observe(.childAdded) { [self] (snapshot) in
            guard let snapDict = snapshot.value as? [String : Any] else {return}
            
            let team = Team(snapDict: snapDict)
            
            self.allTeams.append(team)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
}

// MARK: - TableView Functions

extension SearchTeamTableTableViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table view data source
    
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
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let uid = Auth.auth().currentUser?.uid
        
        var teamClicked = Team()
        
        if searching {
            teamClicked = searchedTeam[indexPath.row]
        } else {
            teamClicked = allTeams[indexPath.row]
        }

        if let uid = uid, let newTeam = teamClicked.name{
            
            DBService.shared.playersInTeam.child(newTeam).updateChildValues([uid: "player id"])
            DBService.shared.teamOfUser.child(uid).updateChildValues([newTeam: "Team name"])
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}

// MARK: - Search Bar Functions

extension SearchTeamTableTableViewController: UISearchBarDelegate {
    
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
}

