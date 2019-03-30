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
   
    static var team = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavBar()
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
