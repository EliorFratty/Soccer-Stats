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

    var players = [Player]()
    var searchedPlayers = [Player]()
    var searching = false
    var addButton: UIBarButtonItem!
    var uid: String?
    let cellID = "playerCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UserCell.self, forCellReuseIdentifier: cellID)
        
        makeNavBar()
        importPlayerFromDB()
        tableView.allowsMultipleSelectionDuringEditing = true
  
    }
    
    // MARK: - DB import
    
    func importPlayerFromDB() {

        self.players.removeAll()
        
        DBService.shared.allTeams.child(TeamViewController.team).child("Players").observe(.childAdded) { [self] (snapshot) in
            guard let snapDict = snapshot.value as? [String : Any] else {return}

            if let fullName = snapDict["fullName"] as? String,
                let email = snapDict["email"] as? String,
                let profileImageUrl = snapDict["profileImageUrl"] as? String {
            
                let player = Player(fullName: fullName,
                                    email: email,
                                    profileImageUrl: profileImageUrl)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        uid = Auth.auth().currentUser?.uid
    }
    
    // MARK: - Add player to DB and TableView
    
    private let cp = CNContactPickerViewController()
    
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
       
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! UserCell
        
        let playerToShow: Player
    
        if searching {
            playerToShow = searchedPlayers[indexPath.row]

        } else {
            playerToShow = players[indexPath.row]
 
        }
        
        cell.textLabel?.text = playerToShow.fullName
        cell.detailTextLabel?.text = playerToShow.email
        
        cell.profileImageView.loadImageUsingCatchWithUrlString(URLString: playerToShow.profileImageUrl)

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        let playerToDelete: String
        
        if searching {
            
            playerToDelete = searchedPlayers[indexPath.row].fullName
            deletePlayerFromTeams(playerToDelete: searchedPlayers[indexPath.row].fullName)
            
        } else  {
            
            playerToDelete = players[indexPath.row].fullName
        }
        
        self.searchedPlayers.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic )
        
        DBService.shared.allTeams.child(TeamViewController.team).child("Players").child(playerToDelete).removeValue(){ (error, ref) in }
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
    
    // MARK: - navBar functions
    
    func makeNavBar() {
        
        addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
        
        self.navigationItem.rightBarButtonItem = addButton
        
    }
    
    // MARK: - Search Bar
    
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
            popUpEror(error123: "this player already exsist")
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

class UserCell: UITableViewCell {
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageAnchor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func profileImageAnchor() {
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8) .isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
}
