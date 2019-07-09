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
    
    let iconsContainerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = .white
        

        // configuration options
        let iconHeight: CGFloat = 45
        let padding: CGFloat = 9
        
        let images = [#imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "surprised"), #imageLiteral(resourceName: "angry"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "cry_laugh")]
        
        let arrangedSubviews = images.map({ (image) -> UIView in
            let imageView = UIImageView(image: image)
            imageView.layer.cornerRadius = iconHeight / 2
            // required for hit testing
            imageView.isUserInteractionEnabled = true
            return imageView

        })
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        
        stackView.spacing = padding
        stackView.layoutMargins = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        
        let numIcons = CGFloat(arrangedSubviews.count)
        let width =  numIcons * iconHeight + (numIcons + 1) * padding
        
        containerView.frame = CGRect(x: 0, y: 0, width: width, height: iconHeight + 2 * padding)
        containerView.layer.cornerRadius = containerView.frame.height / 2
        
        // shadow
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        stackView.frame = containerView.frame
        
        return containerView
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
        
        setupLongPressGesture()
  
    }

    //MARK: - Configurations

    func configurateSearchBar() {
        
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
    
    func makeNavBar() {
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(tapAddButton))
        self.navigationItem.rightBarButtonItem = addButton
        navigationItem.leftBarButtonItem?.tintColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        navigationItem.rightBarButtonItem?.tintColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    }

    //MARK: - Handlers
    
    private let cp = CNContactPickerViewController()
    
    @objc func tapAddButton(){
        cp.delegate = self
        self.present(cp, animated: true, completion: nil)
        
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
    
    fileprivate func setupLongPressGesture() {
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress)))
    }
    
    @objc func handleLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            handleGestureBegan(gesture: gesture)
        } else if gesture.state == .ended {
            
            // clean up the animation
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                self.iconsContainerView.transform = self.iconsContainerView.transform.translatedBy(x: 0, y: 50)
                self.iconsContainerView.alpha = 0
                
            }, completion: { (_) in
                self.iconsContainerView.removeFromSuperview()
            })
            
            
        } else if gesture.state == .changed {
            handleGestureChanged(gesture: gesture)
        }
    }
    
    fileprivate func handleGestureChanged(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.iconsContainerView)
        
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconsContainerView.frame.height / 2)
        
        let hitTestView = iconsContainerView.hitTest(fixedYLocation, with: nil)
        
        if hitTestView is UIImageView {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                
                let stackView = self.iconsContainerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                
                hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
                
            })
        }
    }
    
    fileprivate func handleGestureBegan(gesture: UILongPressGestureRecognizer) {
        view.addSubview(iconsContainerView)
        
        let pressedLocation = gesture.location(in: self.view)
        
        // transformation of the red box
        let centeredX = (view.frame.width - iconsContainerView.frame.width) / 2
        
        iconsContainerView.alpha = 0
        self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y)
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            
            self.iconsContainerView.alpha = 1
            self.iconsContainerView.transform = CGAffineTransform(translationX: centeredX, y: pressedLocation.y - self.iconsContainerView.frame.height)
        })
    }
}

// MARK: - TableView functions

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
        
        cell.player = playerToShow

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
}

// MARK: - SearchBar functions

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


