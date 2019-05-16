//
//  AddTeamViewController.swift
//  Soccer Stats
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class AddTeamViewController: UIViewController {
    
    // MARK:- Propretis
    
    var teams = [Team]()
    
    let erorLabel: UILabel = {
       let lb = UILabel()
        lb.textColor = #colorLiteral(red: 0.9915834069, green: 0.003966939636, blue: 0.1889238358, alpha: 1)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 25.0)

        return lb
    }()
    
    let inputContainerView: UIView = {
        let view = UIView()

        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var addNewTeamButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        button.setTitle("Create", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(createButtonTapped), for: .touchUpInside)
        return button
    }()
    
    let teamNewNameTextFiled: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Team name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.clearButtonMode = .whileEditing
        
        return tf
    }()
    
    let teamDescriptonTextFiled: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Write some words in the team"
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        
        return tf
    }()
    
    let teamImojiTextFiled: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Imoji flag (1 Char)"
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        
        return tf
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboard()
        makeNavigationBar()
     
        setupImageBackgorund()
        
        view.addSubviews(inputContainerView,addNewTeamButton,erorLabel)

        configorateinputContainerView()
        configorateErrorLabelView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        erorLabel.isHidden = true
    }

    // MARK: - Configuration

    func configorateErrorLabelView(){
        
        erorLabel.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        erorLabel.topAnchor.constraint(equalTo: addNewTeamButton.bottomAnchor, constant: 50) .isActive = true
        erorLabel.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        erorLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
    }
    
    func configorateinputContainerView() {
        
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24).isActive = true
        inputContainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        inputContainerView.addSubviews(teamNewNameTextFiled, teamDescriptonTextFiled, teamImojiTextFiled)
        
        teamNewNameTextFiled.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8).isActive = true
        teamNewNameTextFiled.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        teamNewNameTextFiled.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        teamNewNameTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        teamDescriptonTextFiled.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8).isActive = true
        teamDescriptonTextFiled.topAnchor.constraint(equalTo: teamNewNameTextFiled.bottomAnchor).isActive = true
        teamDescriptonTextFiled.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        teamDescriptonTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        teamImojiTextFiled.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 8).isActive = true
        teamImojiTextFiled.topAnchor.constraint(equalTo: teamDescriptonTextFiled.bottomAnchor).isActive = true
        teamImojiTextFiled.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        teamImojiTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
        addNewTeamButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addNewTeamButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor).isActive = true
        addNewTeamButton.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        addNewTeamButton.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3).isActive = true
        
    }
    
    func makeNavigationBar() {
        
        self.title = "Add new Team"
        
        let backButton = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backButtonTapped))
        backButton.tintColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
        navigationItem.leftBarButtonItem = backButton

    }
    
    @objc func backButtonTapped(){
        navigationController?.popToRootViewController(animated: true)

    }
    
    func setupImageBackgorund() {
        let imageView = UIImageView(image: UIImage(named: "newTeamImage"))
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        imageView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor)
        
    }

    @objc func createButtonTapped(_ sender: UIButton) {
        
        //add team to DB, if not exsist
        guard let uid = Auth.auth().currentUser?.uid else {return}
        if let teamName = teamNewNameTextFiled.text,
            let imoji = teamImojiTextFiled.text,
            let desc = teamDescriptonTextFiled.text,
            teamName != "",
            checkTeamName(teamName) {
            guard let userID = Auth.auth().currentUser?.uid else {return}

            // add team's details
            let dateString = String(describing: Date())
            let teamParam = [
                "name"  : String(teamName),
                "summary" : desc,
                "date"  : dateString,
                "imoji" : String(imoji.first ?? "🎱")
            ]

            DBService.shared.allTeams.child(teamName).setValue(teamParam)
            DBService.shared.playersInTeam.child(teamName).updateChildValues([uid: "player id"])
            DBService.shared.teamOfUser.child(userID).updateChildValues([teamName: "Team name"])
 
            dismiss(animated: true, completion: nil)

        } else {
            erorLabel.isHidden = false
            if teamNewNameTextFiled.text == "" {
                erorLabel.text = "You entered empty name!"
            } else {
                erorLabel.text = "This team already exsist"
            }
        }
    }
    
    func checkTeamName(_ teamName:String) -> Bool{

        return teams.filter{ $0.name == teamName }.count == 0

    }
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
