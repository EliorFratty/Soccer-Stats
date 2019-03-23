//
//  PlayersTableViewController.swift
//  Soccer Stats
//
//  Created by User on 09/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class PlayersTableViewController: UITableViewController, UISearchBarDelegate{

    var players = [String]()
    var searchedPlayers = [String]()
    var searching = false
    var playersKeys = [String]()
    var team: String!
    var firstName: UITextField?
    var lastName: UITextField?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        makeNavBar()
        importPlayerFromDB()
        tableView.allowsMultipleSelectionDuringEditing = true
  
    }
    
    func importPlayerFromDB() {
        
         var playerFromDB = [String]()
        var playersKeysFromDB = [String]()
        DBService.shared.playerInTeamRef.observe(.value) { [self] (snapshot) in
            guard let snapDict = snapshot.childSnapshot(forPath: self.team).childSnapshot(forPath: "Players").value as? [String: [String : String]] else {return}
            
            playerFromDB.removeAll()
            playersKeysFromDB.removeAll()
            
            for snap in snapDict {
                let playerName = snap.value["firstName"]!  + " " + snap.value["lastName"]!
                playerFromDB.append(playerName)
                playersKeysFromDB.append(snap.key)
            }
            self.playersKeys = playersKeysFromDB
            self.players = playerFromDB

           // sort player from A-Z
            self.players.sort(by: { (p1, p2) -> Bool in
                return p1 < p2
            })
            
            self.tableView.reloadData()
        }
    }
    
    
    @objc func tapAddButton(){
        let alert = UIAlertController(title: "Add Player", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { [self] (action) in

            self.tableView.reloadData()
            self.addPlayer()

    }
 
        alert.addAction(action)
        alert.addTextField(configurationHandler: firstNameFiled)
        alert.addTextField(configurationHandler: lastNameFiled)
        present(alert,animated: true, completion: nil)
    }
    
    func addPlayer(){
        let param2 = [
            "firstName": firstName?.text,
            "lastName" : lastName?.text
        ]
        
        DBService.shared.playerInTeamRef.child(team).child("Players").childByAutoId().setValue(param2)
    }
    
    func firstNameFiled(textField: UITextField!) {
        firstName = textField
        firstName?.placeholder = "First name"
        
    }
    
    func lastNameFiled(textField: UITextField!) {
        lastName = textField
        lastName?.placeholder = "Last name"

    }
    
    
    
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedPlayers.count
        } else {
            return players.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "playerCell", for: indexPath) as! PlayerTableViewCell
        
       
        if searching {
             cell.playerName.text = players[indexPath.row]
        } else {
             cell.playerName.text = searchedPlayers[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let a = playersKeys[indexPath.row]
        
        self.players.remove(at: indexPath.row)
        
        self.tableView.deleteRows(at: [indexPath], with: .automatic )
        
        DBService.shared.playerInTeamRef.child(self.team).child("Players").child(a).removeValue(){ (error, ref) in }
    }
    
    // MARK: - navBar functions
    
    func makeNavBar() {
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
        
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    // MARK: - Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedPlayers = players.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        self.searching = true
        tableView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class PlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerBackGround: UIView!
    
}
