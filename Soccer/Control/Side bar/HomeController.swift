//
//  HomeController.swift
//  Soccer
//
//  Created by User on 08/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase
import Alamofire

class HomeController: UIViewController {
    
    //MARK: - Properties

    static var userAsPlayer = Player()

    var delegate: HomeControllerDelegate?
    private var allTeams = [Team]()
    private let cellID = "myTeamCell"
    private var changedUser = false
    
    private lazy var tableView: UITableView = {
        let tv = UITableView()
        
        tv.register(ChooseTeamCell.self, forCellReuseIdentifier: cellID)
        tv.keyboardDismissMode = .onDrag
        tv.separatorStyle = .none
        
        return tv
    }()
    
    private let activityIndic: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .gray)
        ai.startAnimating()
        
        return ai
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubviews(tableView)
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)

        configurateNavigationBar()
        configurateTableView()
        checkIfUserIsLoggedIn()
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getPlayerAsUserDetailes()
        reciveTeamsFromDB()
    }
    
    //MARK: - Configurations
    
    func configurateTableView() {
        
        tableView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        
        tableView.addSubview(activityIndic)
        activityIndic.centerInSuperview(size: CGSize(width: 50, height: 50))

    }
    
    func configurateNavigationBar() {
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let profileButton = UIBarButtonItem(title: "Profile", style: .plain, target: self, action: #selector(handleMenuToggle))
        profileButton.tintColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        navigationItem.leftBarButtonItem = profileButton
        
        let searchTeamButton = UIBarButtonItem(title: "Search", style: .plain, target: self, action: #selector(searchTeamFromAllUsers))
        searchTeamButton.tintColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        navigationItem.rightBarButtonItem = searchTeamButton
        
    }

    //MARK: - Handlers
    
    @objc func searchTeamFromAllUsers(){
        
        let searchTeamTableTableViewController = SearchTeamTableTableViewController()
        let navController = UINavigationController(rootViewController: searchTeamTableTableViewController)
        navController.navigationBar.tintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
        
        present(navController, animated: true, completion: nil)
        
    }
    
    @objc func handleMenuToggle() {
        delegate?.handleMenuToggle(forMenuOption: nil)
    }

    // MARK: - Service
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser?.uid == nil {
            let viewCntroller = LogInViewController()
            self.present(viewCntroller, animated: true, completion: nil)
        }
    }
    
    func getPlayerAsUserDetailes() {
        guard let uid = Auth.auth().currentUser?.uid else {print("Error") ; return }
       
        DBService.shared.users.child(uid).observeSingleEvent(of:.value) { [self] (snapshot) in
           
            if let dict = snapshot.value as? [String:Any] {
                
                let player = Player(id: snapshot.key, dict: dict)
                self.navigationItem.title = "Hello \(player.fullName)"
                HomeController.userAsPlayer = player
                self.enabledNavigationBarButtonsStopIndic()
                
            }
        }
    }
    
    func reciveTeamsFromDB() {
        disableNavigationBarButtons()

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
                        
            let team = Team(snapDict: snapDict)
            
            self.allTeams.append(team)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func enabledNavigationBarButtonsStopIndic(){
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        self.navigationItem.rightBarButtonItem?.isEnabled = true
        self.activityIndic.stopAnimating()
    }
    
    func disableNavigationBarButtons(){
        navigationItem.leftBarButtonItem?.isEnabled = false
        navigationItem.rightBarButtonItem?.isEnabled = false
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
        
        guard let uid = Auth.auth().currentUser?.uid else { print("cant find the uid"); return}
        guard let teamToRemove = allTeams[indexPath.row].name else { print("cant find the team name"); return}
        
        allTeams.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic )
        
       
        DBService.shared.teamOfUser.child(uid).child(teamToRemove).removeValue()
        DBService.shared.playersInTeam.child(teamToRemove).child(uid).removeValue()
        
    }
    
    func deleteTeamFromTeams(teamToDelete: String) {
        
        allTeams = allTeams.filter({$0.name != teamToDelete})
    
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        MainUICVC.team = allTeams[indexPath.row]
        
        let flowLayout = UICollectionViewFlowLayout()
        
        let teamViewController = MainUICVC(collectionViewLayout: flowLayout)
        navigationController?.pushViewController(teamViewController, animated: true)
    
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
}
