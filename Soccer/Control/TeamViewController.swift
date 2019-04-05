//
//  TeamTableViewController.swift
//  Soccer Stats
//
//  Created by User on 08/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class TeamViewController: UIViewController {
   
    static var team : String!
    static var player: Player!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavBar()
        addUserToTheTeam()
    }
    
    @objc func logoutTapped(){
        try! Auth.auth().signOut()
        
        let viewCntroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        self.present(viewCntroller, animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
        

    }
    
    @objc func goBackToChooseTeam() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func PlayersTapped(_ sender: UIButton) {
    }
    
    @IBAction func teamStatsTapped(_ sender: UIButton) {
    }
    
    @IBAction func gamesTapped(_ sender: UIButton) {
        
    }
    
    func addUserToTheTeam(){

        let param = ["fullName": TeamViewController.player.fullName,
                     "email" : TeamViewController.player.email,
                     "profileImageUrl" :  TeamViewController.player.profileImageUrl ]

        DBService.shared.allTeams.child(TeamViewController.team).child("Players").child(TeamViewController.player.fullName).setValue(param)
        
    }
    
    // MARK - navBar
    
    func makeNavBar() {
        
        let logoutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logoutTapped))
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackToChooseTeam))
        
        
        self.navigationItem.rightBarButtonItem = logoutButton
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.title = TeamViewController.team
    }
    
    // MARK - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
  
}
