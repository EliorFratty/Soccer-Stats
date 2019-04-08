//
//  AddTeamViewController.swift
//  Soccer Stats
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class AddTeamViewController: UIViewController {
    
    var teams: [Team]?
    var uid: String?
    var teamNameTextField: UITextField?
    var teamAddedToDB: String?
    var erorLabel: UILabel?
    var sameTeam = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        view.backgroundColor = .red

        makeNavBar()
    }
    
    func makeNavBar() {
 
//        navigationBar.topAnchor.constraint(equalTo: view.topAnchor,constant: 50).isActive = true
//        navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
//        navigationBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        navigationBar.heightAnchor.constraint(equalToConstant: 400).isActive = true
//        let navigationItem = UINavigationItem()

         navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelTapped))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(cancelTapped))

        
    }
    
    @objc func cancelTapped(){
        dismiss(animated: true, completion: nil)
    }
    


    
   
    func goTapped(_ sender: UIButton) {
        
        //add team to DB, if not exsist
        if let teamName = teamNameTextField?.text,
            teamName != "",
            checkTeamName(teamName) {
            
            guard let userID = Auth.auth().currentUser?.uid else {return}
            
            // add team's details
            let dateString = String(describing: Date())
            let teamParam = [
                "name"  : String(teamName),
                "date"  : dateString,
                "imoji" : ""
            ]
            
            let userParam = [
                "team": teamName
            ]
            
            DBService.shared.allTeams.child(teamName).setValue(teamParam)
            DBService.shared.users.child(userID).child("teams").child(teamName).setValue(userParam)
            
            teamAddedToDB = teamName
            
            
        } else {
            erorLabel?.isHidden = false
            if teamNameTextField?.text == "" {
                erorLabel?.text = "You entered empty name!"
            } else {
                erorLabel?.text = "This team already exsist"
            }
            sameTeam = true
        }
    }
    
    func checkTeamName(_ teamName:String) -> Bool{
        if let teams = teams {
        teams.forEach { (team) in
            if team.name == teamName {
                self.sameTeam = false
                }
            }
        } else {
            erorLabel?.isHidden = false
            erorLabel?.text = "Data is Loading... try again in 1 sec"
        }
        
        return sameTeam
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        erorLabel?.isHidden = true
        sameTeam = true
    }
 
    // MARK: - extensions
}

extension UIViewController {
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(DismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func DismissKeyboard(){
        view.endEditing(true)
    }
}
