//
//  PlayersTableViewController.swift
//  Soccer Stats
//
//  Created by User on 09/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase
import Contacts
import ContactsUI

class PlayersTableViewController: UITableViewController, UISearchBarDelegate{

    var players = [String]()
    var searchedPlayers = [String]()
    var searching = false
    var addButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavBar()
        importPlayerFromDB()
        tableView.allowsMultipleSelectionDuringEditing = true
  
    }
    
    // MARK: - DB import
    
    func importPlayerFromDB() {
        
         var playerFromDB = [String]()
        var playersKeysFromDB = [String]()
        DBService.shared.playerInTeamRef.observe(.value) { [self] (snapshot) in
            guard let snapDict = snapshot.childSnapshot(forPath: TeamViewController.team).childSnapshot(forPath: "Players").value as? [String: [String : String]] else {return}
            
            playerFromDB.removeAll()
            
            for snap in snapDict {
                let playerName = snap.value["firstName"]!  + " " + snap.value["lastName"]!
                playerFromDB.append(playerName)
                playersKeysFromDB.append(snap.key)
            }
            self.players = playerFromDB

           // sort player from A-Z
            self.players.sort(by: { (p1, p2) -> Bool in
                return p1 < p2
            })
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Add player to DB and TableView
    
    @objc func tapAddButton(){
        cp.delegate = self
        self.present(cp, animated: true, completion: nil)

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
             cell.playerName.text = searchedPlayers[indexPath.row]
        } else {
             cell.playerName.text = players[indexPath.row]
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if searching {
            let playerToDelete = searchedPlayers[indexPath.row]
            print(playerToDelete)
            
            deletePlayerFromTeams(playerToDelete: searchedPlayers[indexPath.row])
            self.searchedPlayers.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic )
            
            DBService.shared.playerInTeamRef.child(TeamViewController.team).child("Players").child(playerToDelete).removeValue(){ (error, ref) in }

        } else  {
        let playerToDelete = players[indexPath.row]

        self.players.remove(at: indexPath.row)
            
        self.tableView.deleteRows(at: [indexPath], with: .automatic )
        
        DBService.shared.playerInTeamRef.child(TeamViewController.team).child("Players").child(playerToDelete).removeValue(){ (error, ref) in }
        }
        
        tableView.reloadData()
    }
    
    func deletePlayerFromTeams(playerToDelete: String) {
        var indexPlayerToDelete = 0
        
        for player in players {
            if player == playerToDelete {
                break
            }
            indexPlayerToDelete += 1
        }
        
        players.remove(at: indexPlayerToDelete)

    }
    
    // MARK: - navBar functions
    
    func makeNavBar() {
        
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
        
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    // MARK: - Search Bar
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedPlayers = players.filter({$0.lowercased().prefix(searchText.count) == searchText.lowercased()})
        self.searching = true
        //addButton.isEnabled = false
        tableView.reloadData()

    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
      //  addButton.isEnabled = true
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
    
    private let cp = CNContactPickerViewController()

}

class PlayerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var playerImage: UIImageView!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var playerBackGround: UIView!
    
}

// MARK: - add player from Contact with whatsapp

extension PlayersTableViewController: CNContactPickerDelegate {
    
    func addPlayer(firstName:String,lastName:String, phoneNumber: String ){
        let param2 = [
            "firstName": firstName,
            "lastName" : lastName
        ]
        
        let name = firstName + " " + lastName
        
        if checkIfNameExsists(playerName: name){
            dismiss(animated: true)
            popUpEror(error123: "this player already exsist")
        } else {
            let contactPhoneNumber = setNumberFromContact(contactNumber: phoneNumber)
            
            sendMassageToWhatsapp(msg: "For playing in my team you need to download this app", number: contactPhoneNumber)
            DBService.shared.playerInTeamRef.child(TeamViewController.team).child("Players").child(name).setValue(param2)
            self.tableView.reloadData()
        }
  
    }
    
    func checkIfNameExsists(playerName: String) -> Bool {
        for player in players {
            if player == playerName {
                return true
            }
        }
        return false
    }
    
    func contactPicker(_ picker: CNContactPickerViewController, didSelect contact: CNContact) {
        let phoneNumberCount = contact.phoneNumbers.count
        let firstName = contact.givenName
        let lastName = contact.familyName
        
        guard phoneNumberCount > 0 else {
            dismiss(animated: true)
            popUpEror(error123: "Selected contact does not have a number")
            return
        }
        
        if phoneNumberCount == 1 {
            addPlayer(firstName: firstName,lastName: lastName, phoneNumber: contact.phoneNumbers[0].value.stringValue)
            
        } else {
            let alertController = UIAlertController(title: "Select one of the numbers", message: nil, preferredStyle: .alert)
            
            for i in 0...phoneNumberCount-1 {
                let phoneAction = UIAlertAction( title: contact.phoneNumbers[i].value.stringValue, style: .default, handler: { [self]
                    alert -> Void in
                    self.addPlayer(firstName: firstName,lastName: lastName, phoneNumber: contact.phoneNumbers[0].value.stringValue)
                })
                alertController.addAction(phoneAction)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
            alertController.addAction(cancelAction)
            
            dismiss(animated: true)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func setNumberFromContact(contactNumber: String) -> String {
        
        //UPDATE YOUR NUMBER SELECTION LOGIC AND PERFORM ACTION WITH THE SELECTED NUMBER
        print(contactNumber)
        var contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "(", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: "‑", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: " ", with: "")
        contactNumber = contactNumber.replacingOccurrences(of: ")", with: "")
        contactNumber = "0" + String(contactNumber.suffix(10)).dropFirst()
 
        return contactNumber
    }
    
    func sendMassageToWhatsapp(msg: String, number: String) {
        let urlWhats = "whatsapp://send?phone=+972\(number.dropFirst())&text=\(msg)"
        
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: characterSet){
            
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL){
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
                }
                else {
                    print("Install Whatsapp")
                    
                }
            }
        }
    }
    
    func contactPickerDidCancel(_ picker: CNContactPickerViewController) {

    }
    
}
