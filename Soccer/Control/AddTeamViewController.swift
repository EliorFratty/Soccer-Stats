//
//  AddTeamViewController.swift
//  Soccer Stats
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class AddTeamViewController: UIViewController {
    
    var teams: [String]?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
    }
    
    @IBOutlet weak var teamNameTextField: UITextField!
    
    var sameTeam = true
    
    var teamAddedToDB: String?
    
    @IBOutlet weak var erorLabel: UILabel!
    
    @IBAction func goTapped(_ sender: UIButton) {
        
        //add team to DB, if not exsist
        if let teamName = teamNameTextField.text, teamName != "", checkTeamName(teamName){
            
            // add team's details
            let dateString = String(describing: Date())
            let param = [
                "name": teamName,
                "date" : dateString
            ]
            
            DBService.shared.playerInTeamRef.child(teamName).setValue(param)
            teamAddedToDB = teamName
            
            self.performSegue(withIdentifier: "showTeam1", sender: self)
            
        } else {
            erorLabel.isHidden = false
            if teamNameTextField.text == "" {
                erorLabel.text = "You entered empty name!"
            } else {
                erorLabel.text = "This team already exsist"
            }
            sameTeam = true
        }
    }
    
    func checkTeamName(_ teamName:String) -> Bool{
        if let teams = teams {
        teams.forEach { (team) in
            if team == teamName {
                self.sameTeam = false
                }
            }
        } else {
            erorLabel.isHidden = false
            erorLabel.text = "Data is Loading... try again in 1 sec"
        }
        
        return sameTeam
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        erorLabel.isHidden = true
        sameTeam = true
    }    
    

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let _ = segue.destination as? TeamViewController {
            if let addedTeamName = teamAddedToDB{
                TeamViewController.team = addedTeamName
            }
        }
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
