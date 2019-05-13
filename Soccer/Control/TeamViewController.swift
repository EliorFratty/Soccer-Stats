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
    
    // MARK:- Propreties
    
    var datePicker: UIDatePicker?
    let cellId = "gameCell"
    var isOpen = true
    
    static var team : Team!
    let player = HomeController.userAsPlayer
    let userTeam = TeamViewController.team

    var games = [Game]()

    let addNewGameInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let newGameAddDateTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Date && Hour"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        tf.keyboardType = .emailAddress
        
        return tf
    }()
    
    let newGameAddLocationTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Location"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        
        return tf
    }()
    
    lazy var newGameAddButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Create", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(newGameAddButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var newGameCancelButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(newGameCancelButtonTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tb = UITableView()
        tb.translatesAutoresizingMaskIntoConstraints = false
        tb.backgroundColor = .black
        tb.register(GameCell.self, forCellReuseIdentifier: cellId)
        return tb
    }()

    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var playersButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Players", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(playersTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var futureGameButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Next matches", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(futureGameTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var previousGameButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.setTitle("Previous games", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(previousGameTapped), for: .touchUpInside)
        return button
    }()

    
    lazy var addNewGameButton : UIButton = {
        let button = UIButton()
        button.setTitle("New Game", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(addNewGameTapped), for: .touchUpInside)
        return button
    }()

    // MARK:- Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow
        getAllGamesFromDB()
       
        tableView.delegate = self
        tableView.dataSource = self
        
        makeDatePicker()
        makeNavBar()
        
        view.addSubview(inputContainerView)
        view.addSubview(addNewGameButton)
        view.addSubview(addNewGameInputContainerView)
        
        setupinputContainerViewConstraint()
        setUpaddNewGameInputContainerView()
        
    }
    
    //MARK:- Services
    
    func getAllGamesFromDB() {
        guard let userTeam = userTeam else {return}
        guard let userTeamName = userTeam.name else {return}

        DBService.shared.games.child(userTeamName).observeSingleEvent(of: .value) { [self] (snapshot) in
            if let teamGames = snapshot.value as? [String:[String:Any]] {
                
                let releaseDateFormatter = DateFormatter()
                releaseDateFormatter.dateFormat = "dd-MM-yyyy"
                
                for games in teamGames {
                    let date = games.key
                    let hour = games.value["hour"] as! String
                    let location = games.value["location"] as! String
                    let isComing = self.checkIfPlayerIsComingToGame(playersInGame: games.value["players"] as? [String:Any])
                    
                    let gameDate = releaseDateFormatter.date(from: date)
                    
                    if gameDate!.compare(Date()) == .orderedDescending {
                        let game = Game(date:date, hour: hour, place: location, isComing: isComing)
                        self.games.append(game)
                    }
                }

                self.games.sort(by: { (game1, game2) -> Bool in
                    
                    
                    let date1 = releaseDateFormatter.date(from: game1.date)
                    let date2 = releaseDateFormatter.date(from: game2.date)
                    return date1?.compare(date2!) == .orderedAscending
                    
                })
                self.tableView.reloadData()
            }
        }
    }
    
    func checkIfPlayerIsComingToGame(playersInGame: [String:Any]?) -> Bool{
        if let pGames = playersInGame {
            for playerInGame in pGames {
                if playerInGame.key == player.fullName {
                    return true
                }
            }
        }
        return false
    }
    
    // MARK:- Anchors
    var tableViewHeightAnchor = NSLayoutConstraint()
    var tableViewTopAnchor = NSLayoutConstraint()
    var inputContainerViewHeightAnchor = NSLayoutConstraint()
    
    func setupinputContainerViewConstraint(){
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -24).isActive = true
        inputContainerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContainerViewHeightAnchor.isActive = true
        
        inputContainerView.addSubview(playersButton)
        inputContainerView.addSubview(previousGameButton)
        inputContainerView.addSubview(futureGameButton)
        inputContainerView.addSubview(tableView)

        playersButton.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        playersButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        playersButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        playersButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tableViewTopAnchor = futureGameButton.topAnchor.constraint(equalTo: playersButton.bottomAnchor)
        tableViewTopAnchor.isActive = true
        futureGameButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        futureGameButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        futureGameButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        previousGameButton.topAnchor.constraint(equalTo: futureGameButton.bottomAnchor).isActive = true
        previousGameButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        previousGameButton.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        previousGameButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

        tableView.topAnchor.constraint(equalTo: futureGameButton.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        tableViewHeightAnchor = tableView.heightAnchor.constraint(equalToConstant: 0)
        tableViewHeightAnchor.isActive = true

        addNewGameButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        addNewGameButton.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        addNewGameButton.widthAnchor.constraint(equalToConstant: 100) .isActive = true
        addNewGameButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    var NewGameInputContainerViewHeightAnchor = NSLayoutConstraint()
    
    func setUpaddNewGameInputContainerView() {
        addNewGameInputContainerView.topAnchor.constraint(equalTo: addNewGameButton.topAnchor, constant: 20).isActive = true
        addNewGameInputContainerView.leftAnchor.constraint(equalTo: addNewGameButton.leftAnchor, constant: 10).isActive = true
        addNewGameInputContainerView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor) .isActive = true
        NewGameInputContainerViewHeightAnchor = addNewGameInputContainerView.heightAnchor.constraint(equalToConstant: 0)
        NewGameInputContainerViewHeightAnchor.isActive = true
        
        addNewGameInputContainerView.addSubview(newGameAddDateTextField)
        addNewGameInputContainerView.addSubview(newGameAddLocationTextField)
        addNewGameInputContainerView.addSubview(newGameAddButton)
        addNewGameInputContainerView.addSubview(newGameCancelButton)
        

        newGameAddDateTextField.delegate = self
        newGameAddLocationTextField.delegate = self
        
        newGameAddDateTextField.topAnchor.constraint(equalTo: addNewGameInputContainerView.topAnchor).isActive = true
        newGameAddDateTextField.leftAnchor.constraint(equalTo: addNewGameInputContainerView.leftAnchor).isActive = true
        newGameAddDateTextField.widthAnchor.constraint(equalTo: addNewGameInputContainerView.widthAnchor).isActive = true
        newGameAddDateTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        newGameAddLocationTextField.topAnchor.constraint(equalTo: newGameAddDateTextField.bottomAnchor).isActive = true
        newGameAddLocationTextField.leftAnchor.constraint(equalTo: addNewGameInputContainerView.leftAnchor).isActive = true
        newGameAddLocationTextField.widthAnchor.constraint(equalTo: addNewGameInputContainerView.widthAnchor).isActive = true
        newGameAddLocationTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        newGameAddButton.topAnchor.constraint(equalTo: newGameAddLocationTextField.bottomAnchor).isActive = true
        newGameAddButton.leftAnchor.constraint(equalTo: addNewGameInputContainerView.leftAnchor).isActive = true
        newGameAddButton.widthAnchor.constraint(equalTo: addNewGameInputContainerView.widthAnchor, multiplier: 1/2).isActive = true
        newGameAddButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        newGameCancelButton.topAnchor.constraint(equalTo: newGameAddLocationTextField.bottomAnchor).isActive = true
        newGameCancelButton.leftAnchor.constraint(equalTo: newGameAddButton.rightAnchor).isActive = true
        newGameCancelButton.widthAnchor.constraint(equalTo: addNewGameInputContainerView.widthAnchor, multiplier: 1/2).isActive = true
        newGameCancelButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }

    // MARK:- Handlers
    
    func makeDatePicker() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .dateAndTime
        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
        
        newGameAddDateTextField.inputView = datePicker
    }
    
    @objc func addNewGameTapped() {
        self.NewGameInputContainerViewHeightAnchor.constant = 150
            UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func newGameCancelButtonTapped() {
        NewGameInputContainerViewHeightAnchor.constant = 0
    }

    @objc func newGameAddButtonTapped() {
        NewGameInputContainerViewHeightAnchor.constant = 0
        
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        if newGameAddDateTextField.text! != "" {
            let alert = UIAlertController(title: "You created new game", message: "at: \(newGameAddDateTextField.text!) \n\(newGameAddLocationTextField.text!)", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.createNewGame(dateHour: self.newGameAddDateTextField.text!, location:self.newGameAddLocationTextField.text!)
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            alert.addAction(action)
            alert.addAction(cancelAction)
            present(alert,animated: true, completion: nil)
        }
    }
    
    func createNewGame(dateHour:String, location: String){
        guard let userTeam = userTeam else {return}
        guard let userTeamName = userTeam.name else {return}
        let date = String(dateHour.split(separator: " ").first!).replacingOccurrences(of: "/", with: "-")
        let hour = String(dateHour.split(separator: " ").last!)

        let param = ["hour": hour,
            "location":location
        ]
        
        DBService.shared.games.child(userTeamName).child(date).setValue(param)
    }

    @objc func playersTapped() {
        let playerTableViewController = PlayersTableViewController()
        navigationController?.pushViewController(playerTableViewController, animated: true)
    }

    @objc func previousGameTapped(){
        let previousGameViewController = PreviousGameViewController()
        present(previousGameViewController, animated: true, completion: nil)
    }
    
    @objc func futureGameTapped(){
        
        if games.isEmpty {
            let alert = UIAlertController(title: "No game to show", message: "This team has no game to show", preferredStyle: .alert)
            let action = UIAlertAction(title: "Ok", style: .default) { (action) in }
            alert.addAction(action)
            present(alert,animated: true, completion: nil)
        }
        
        if isOpen {
            self.tableViewHeightAnchor.constant = CGFloat(50 * games.count)
            self.inputContainerViewHeightAnchor.constant = CGFloat(150 + 50 * games.count)
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
            
        } else {
            self.tableViewHeightAnchor.constant = 0
            self.inputContainerViewHeightAnchor.constant = 150
            
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
                
            }
        }
        isOpen = !isOpen
    }

    // MARK: - navBar
    
    func makeNavBar() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "?????", style: .plain, target: self, action: #selector(funcToDoSomthing))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackToChooseTeam))
        self.navigationItem.title = TeamViewController.team.name! + " Team"
    }
    
    @objc func goBackToChooseTeam() {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
         let dateFormatter = DateFormatter()
         dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
        newGameAddDateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    
    @objc func funcToDoSomthing(){
        popUpEror(error: "What can i do here??")
    }
}
    
    

// MARK: - TableView Functions


extension TeamViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! GameCell
        
        cell.Game = games[indexPath.row]
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let futureGameViewController = FutureGameViewController()
        futureGameViewController.game = games[indexPath.row]
        present(futureGameViewController, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}

extension TeamViewController: gameCellDelegate {
    
    func IsComingToGame(yesOrNo: Bool, date: String) {
        guard let userTeam = userTeam else {return}
        guard let userTeamName = userTeam.name else {return}
        
        
        if yesOrNo {
            let param = ["name": player.fullName]
            DBService.shared.games.child(userTeamName).child(date).child("players").child(player.fullName).setValue(param)
        } else {
            DBService.shared.games.child(userTeamName).child(date).child("players").child(player.fullName).removeValue()
        }
    }
}

