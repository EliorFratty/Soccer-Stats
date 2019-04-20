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

class PlayersTableViewController: UIViewController{
    
    // MARK: - Properties

    var players = [Player]()
    var searchedPlayers = [Player]()
    var searching = false
    let cellID = "playerCell"
    
    let player = HomeController.userAsPlayer
    let userTeam = TeamViewController.team
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.register(UserCell.self, forCellReuseIdentifier: cellID)
        tb.backgroundColor = .white
        tb.keyboardDismissMode = .onDrag

        tb.translatesAutoresizingMaskIntoConstraints = false
        return tb
    }()
    
    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.translatesAutoresizingMaskIntoConstraints = false
        
        return sb
    }()
    
    // MARK: - Lifecycle

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        configurateSearchBar()
        configurateTableView()
        
        makeNavBar()
        importTeamPlayersFromDB()
        tableView.allowsMultipleSelectionDuringEditing = true
  
    }
    
    // MARK: - Hendlers

    func configurateSearchBar() {
        //x,y,width,height
        
        searchBar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        searchBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive =  true
        searchBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func configurateTableView() {
        
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    // MARK: - Services
    
    func importTeamPlayersFromDB() {

        self.players.removeAll()
        
        guard let userTeam = userTeam else {return}
        guard let teamName = userTeam.name else {return}

        DBService.shared.playersInTeam.child(teamName).observe(.value) { [self] (snapshot) in
            guard let snapDict = snapshot.value as? [String : Any] else {return}
            
            for user in snapDict {
                self.importPlayers(user: user.key)
            }
        
        }
    }
    
    func importPlayers(user: String){
        
        DBService.shared.users.child(user).observeSingleEvent(of: .value) { (snapshot) in
            guard let snapDict = snapshot.value as? [String : Any] else {return}
            print(snapDict)
            if let fullName = snapDict["fullName"] as? String,
                let email = snapDict["email"] as? String,
                let profileImageUrl = snapDict["profileImageUrl"] as? String {

                let player = Player(id:snapshot.key,
                                    fullName: fullName,
                                    email: email,
                                    ProfileUrl: profileImageUrl)
                self.players.append(player)
            }

            // sort player from A-Z
            self.players.sort(){ (p1, p2) -> Bool in
                return p1.fullName < p2.fullName
            }

            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Add player to DB and TableView
    
    private let cp = CNContactPickerViewController()
    
    @objc func tapAddButton(){
        cp.delegate = self
        self.present(cp, animated: true, completion: nil)

    }
    


    func makeNavBar() {
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
        self.navigationItem.rightBarButtonItem = addButton
    }
}

// MARK: - Table view data source

extension PlayersTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching {
            return searchedPlayers.count
        } else {
            return players.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        let playerToShow: Player
        
        if searching {
            playerToShow = searchedPlayers[indexPath.row]
            
        } else {
            playerToShow = players[indexPath.row]
        }
        
        cell.Player = playerToShow

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let playerToDelete: String
        
        if searching {
            
            playerToDelete = searchedPlayers[indexPath.row].fullName
            deletePlayerFromTeams(playerToDelete: searchedPlayers[indexPath.row].fullName)
            
        } else  {
            
            playerToDelete = players[indexPath.row].fullName
        }
        
        self.searchedPlayers.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic )
        
        DBService.shared.allTeams.child(TeamViewController.team.name!).child("Players").child(playerToDelete).removeValue(){ (error, ref) in }
        tableView.reloadData()
    }
    
    func deletePlayerFromTeams(playerToDelete: String) {
        var indexPlayerToDelete = 0
        
        for player in players {
            let name = player.fullName
            if name == playerToDelete {
                break
            }
            indexPlayerToDelete += 1
        }
        
        players.remove(at: indexPlayerToDelete)
    }
}

extension PlayersTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchedPlayers = players.filter({$0.fullName.lowercased().prefix(searchText.count) == searchText.lowercased()})
        self.searching = true
        tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        searchBar.text = ""
        tableView.reloadData()
    }
}



// MARK: - add player from Contact with whatsapp

extension PlayersTableViewController: CNContactPickerDelegate {
    
    func addPlayer(firstName:String,lastName:String, phoneNumber: String ){
        
        let name = firstName + " " + lastName
        
        if checkIfNameExsists(playerName: name){
            dismiss(animated: true)
            popUpEror(error: "this player already exsist")
        } else {
            let contactPhoneNumber = setNumberFromContact(contactNumber: phoneNumber)
            
            sendMassageToWhatsapp(msg: "For playing in my team you need to download this app", number: contactPhoneNumber)
            self.tableView.reloadData()
        }
  
    }
    
    func checkIfNameExsists(playerName: String) -> Bool {
        for player in players {
            let name = player.fullName
            if name == playerName {
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
            popUpEror(error: "Selected contact does not have a number")
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


