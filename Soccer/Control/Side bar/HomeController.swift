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
    var allTeams = [Team]()
    let cellID = "myTeamCell"
    var changedUser = false

    static var userAsPlayer = Player()
    
    var tableView: UITableView!
    
    let activityIndic: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.startAnimating()
        
        return ai
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurateNavigationBar()
        configurateTableView()
        checkIfUserIsLoggedIn()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPlayerAsUserDetailes()
        reciveTeamsFromDB()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - service
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            let viewCntroller = LogInViewController()
            self.present(viewCntroller, animated: true, completion: nil)
        }
    }
    
    func getPlayerAsUserDetailes() {
        guard let uid = Auth.auth().currentUser?.uid else {print("Error") ; return }
       
        DBService.shared.users.child(uid).observeSingleEvent(of:.value) {(snapshot) in
            if let dict = snapshot.value as? [String:Any] {
                if let name = dict["fullName"] as? String,
                    let email = dict["email"] as? String,
                    let profileImageUrl = dict["profileImageUrl"] as? String{
                   
                    HomeController.userAsPlayer = Player(id: snapshot.key, fullName: name, email:email, ProfileUrl:profileImageUrl)
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.navigationItem.title = "Hello \(name)"
                    self.activityIndic.stopAnimating()
                }
            }
        }
    }
    
    func reciveTeamsFromDB() {
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
        guard let uid = Auth.auth().currentUser?.uid else {print("Error to get uid") ; return }

        allTeams.removeAll()
        DBService.shared.teamOfUser.child(uid).observeSingleEvent(of: .value) { [self] (snapshot) in
            
            if let teamsName = snapshot.value as? [String:Any] {

                for teamName in teamsName {
                    self.getUserTeamDetailesFromDB(teamName: teamName.key)
                }
            }
        }
    }
    
    func getUserTeamDetailesFromDB(teamName: String ) {
        
        DBService.shared.allTeams.child(teamName).observe(.value, with: { (snapshot) in
            self.activityIndic.stopAnimating()

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
    
    //MARK: - Configurations
    
    func configurateTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self

        tableView.register(ChooseTeamCell.self, forCellReuseIdentifier: cellID)
        tableView.backgroundColor = .darkGray
        tableView.keyboardDismissMode = .onDrag
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        tableView.addSubview(activityIndic)
        activityIndic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndic.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndic.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndic.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func configurateNavigationBar() {
        navigationController?.navigationBar.barTintColor = .green
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let addTeamButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(handleMenuToggle))
        navigationItem.leftBarButtonItem = addTeamButton
        
        let searchTeamButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchTeamFromAllUsers))
        navigationItem.rightBarButtonItem = searchTeamButton
        
    }
    //MARK: - Handlers
    
    @objc func searchTeamFromAllUsers(){
        
        let searchTeamTableTableViewController = SearchTeamTableTableViewController()
        let navController = UINavigationController(rootViewController: searchTeamTableTableViewController)
        present(navController, animated: true, completion: nil)
    }

    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
        
    }
}

// MARK: - TAbleView Functions

extension HomeController: UITableViewDataSource, UITableViewDelegate {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

            return allTeams.count  
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ChooseTeamCell
        
        cell.team = allTeams[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let teamToRemove: String
        guard let uid = Auth.auth().currentUser?.uid else { print("cant find the uid"); return}
        
        teamToRemove = allTeams[indexPath.row].name!
        
        allTeams.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic )
        DBService.shared.teamOfUser.child(uid).child(teamToRemove).removeValue()
        DBService.shared.playersInTeam.child(teamToRemove).child(uid).removeValue()
    }
    
    func deleteTeamFromTeams(teamToDelete: String) {
        
        allTeams = allTeams.filter({$0.name! != teamToDelete})
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        TeamViewController.team = allTeams[indexPath.row]
        
        let teamViewController = TeamViewController()
        navigationController?.pushViewController(teamViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
