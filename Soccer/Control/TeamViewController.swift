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
    
    
    let showPlayersLabel: UILabel = {
       let lb = UILabel()
       lb.text = "Players"
        
        
        return lb
        
    }()

   
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        makeNavBar()
        //addUserToTheTeam()
        
        //view.addSubview(showPlayersLabel)
       // showPlayerAnchors()
    }
    
    func showPlayerAnchors(){
//        showPlayersLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: -20).isActive = true
//        showPlayersLabel.leftAnchor.constraint(equalTo: view.lefAnchor).isActive = true
//        showPlayersLabel.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
//        showPlayersLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        
//        guard let uid = Auth.auth().currentUser?.uid else {print("Error") ; return }
//        
//        DBService.shared.users.child(uid).observe(.value) {(snapshot) in
//            if let dict = snapshot.value as? [String:Any] {
//                print("this is check")
//                
//                if let name = dict["fullName"] as? String,
//                    let email = dict["email"] as? String,
//                    let profileImageUrl = dict["profileImageUrl"] as? String{
//                    TeamViewController.player = Player(id: snapshot.key, fullName: name, email:email, profileImageUrl:profileImageUrl)
//                }
//            } else {
//                TeamViewController.player = Player(id: "noId", fullName: "ploni almoni", email:"ploniAlmoni@gamel.com", profileImageUrl:"profileImageUrl")
//            }
//        }
    }
    
    
  
    func addUserToTheTeam(){

       // let param = ["fullName": TeamViewController.player.fullName]

       // DBService.shared.allTeams.child(TeamViewController.team).child("Players").child(TeamViewController.player.fullName).setValue(param)
        
    }
    
    // MARK - navBar
    
    func makeNavBar() {
        
        //let logoutButton = UIBarButtonItem(title: "Log out", style: .plain, target: self, action: #selector(logoutTapped))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "logOut", style: .plain, target: self, action: #selector(logoutTapped))

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackToChooseTeam))

        self.navigationItem.title = TeamViewController.team + " Team"
    }
    
    @objc func goBackToChooseTeam() {
        _ = navigationController?.popToRootViewController(animated: true)
    }
    
    
    @objc func logoutTapped(){
        try! Auth.auth().signOut()
        
        let viewCntroller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        self.present(viewCntroller, animated: true, completion: nil)
        navigationController?.popToRootViewController(animated: true)
        
    }

    
    
    // MARK - Segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

    }
    
  
}
