//
//  HomeController.swift
//  Soccer
//
//  Created by User on 08/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase
import LBTATools
import Alamofire

class HomeController: UIViewController {
    
    //MARK: - Properties

    static var userAsPlayer = Player()

    
    var delegate: HomeControllerDelegate?
    private var allTeams = [Team]()
    private let cellID = "myTeamCell"
    private var changedUser = false
    
    private let soccerLiveUrl = "https://apifootball.com/api/?action=get_events%20=1&match_live%20=%201&APIkey=6898d37af29b4c86c79b6ce8ed7b1a0460287feb62cf77bab528e1334674d0fc"

    private lazy var tableView: UITableView = {
        let tv = UITableView()
        
        tv.register(ChooseTeamCell.self, forCellReuseIdentifier: cellID)
        tv.keyboardDismissMode = .onDrag
        tv.separatorStyle = .none
        
        return tv
    }()
    
    private let liveScoreLabel = UILabel(text: "", font: UIFont(name: "Arial", size: 25), textColor: #colorLiteral(red: 0.7450980544, green: 0.1568627506, blue: 0.07450980693, alpha: 1), textAlignment: .left, numberOfLines: 1)
    
    private let activityIndic: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .gray)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.startAnimating()
        
        return ai
    }()

    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        view.addSubviews(tableView, liveScoreLabel)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }
    
    //MARK: - Configurations
    
    func configurateTableView() {
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 1/3).isActive = true
        
        tableView.addSubview(activityIndic)
        activityIndic.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndic.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndic.widthAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndic.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        liveScoreLabel.anchor(top: tableView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 10, bottom: 0, right: 0)  , size: .init(width: 0, height: 0))
        liveScoreLabel.isHidden = true
        
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
                if let name = dict["fullName"] as? String,
                    let email = dict["email"] as? String,
                    let profileImageUrl = dict["profileImageUrl"] as? String{
                   
                    HomeController.userAsPlayer = Player(id: snapshot.key, fullName: name, email:email, ProfileUrl:profileImageUrl)
                    self.navigationItem.leftBarButtonItem?.isEnabled = true
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    self.liveScoreLabel.isHidden = false
                    self.navigationItem.title = "Hello \(name)"
                    self.activityIndic.stopAnimating()
                    self.fetchJSON()
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
            team.teamSummary = snapDict["summary"] as? String
            team.teamImoji = snapDict["imoji"] as? String ?? "A"
            
            self.allTeams.append(team)

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        })
    }
    
    func fetchJSON() {
        getJSON { [self] (json, error) in
            if let error = error {
                print("Can't fetch json", error)
                return
            }
            
            if let jsonArray = json {
                
                if jsonArray.isEmpty {
                    self.liveScoreLabel.text = "No live game at this moment"
                }
                
                for liveGame in jsonArray {
                    print(liveGame)
                }
            }
        }
    }
    
    typealias WebServicesResponse = ([[String:Any]]?, Error?) -> Void
    
    func getJSON(completion: @escaping WebServicesResponse) {
        Alamofire.request(soccerLiveUrl).validate().responseJSON { (response) in
            if let error = response.error {
                completion(nil,error)
                
            } else if let jsonArray = response.result.value as? [[String:Any]] {
                completion(jsonArray,nil)
                
            } else if let jsonDict = response.result.value as? [String:Any] {
                completion([jsonDict],nil)
                
            }
        }
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
        let teamToRemove = allTeams[indexPath.row].name!
        
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
