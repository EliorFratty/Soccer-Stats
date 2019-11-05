//
//  GamesVC.swift
//  Soccer
//
//  Created by User on 08/09/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class GamesVC: UIViewController {
    
    var datePicker: UIDatePicker?
    
    private let textDesign = TextDesign()
    
    static var team : Team!
    let player = HomeController.userAsPlayer
    let userTeam = TeamViewController.team
    
    private let ButtonsFontSize: CGFloat = 30

    lazy var FutureGameButton : UIButton = {
        let button = UIButton(type: .custom)
        
        button.setBackgroundImage(#imageLiteral(resourceName: "FutureGameImage"), for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Future Games", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: ButtonsFontSize)
        
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(FutureGameTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var PreviousGameButton : UIButton = {
        let button = UIButton(type: .custom)
        
        button.setBackgroundImage(#imageLiteral(resourceName: "PreviusGameImage"), for: .normal)
        
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Previous Games", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: ButtonsFontSize)
        
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(previousGameTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var CreateNewGameButton : UIButton = {
        let button = UIButton(type: .custom)
        
        button.setBackgroundImage(#imageLiteral(resourceName: "startNewGameImage"), for: .normal)
        
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Create new game", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: ButtonsFontSize)
        
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(createNewGameTapped), for: .touchUpInside)
        return button
    }()
    
//    let addNewGameInputContainerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.layer.cornerRadius = 5
//        view.layer.masksToBounds = true
//        return view
//    }()
//
//    let newGameAddDateTextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Choose Date & Hour"
//        tf.clearButtonMode = .whileEditing
//        tf.keyboardType = .emailAddress
//
//        return tf
//    }()
//
//    let newGameAddLocationTextField: UITextField = {
//        let tf = UITextField()
//        tf.placeholder = "Where we play?"
//        tf.clearButtonMode = .whileEditing
//
//        return tf
//    }()
    
//    lazy var newGameCreateButton : UIButton = {
//        let button = UIButton()
//        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//        button.setTitle("Create", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        button.layer.cornerRadius = 5
//        button.layer.masksToBounds = true
//
//        button.addTarget(self, action: #selector(newGameAddButtonTapped), for: .touchUpInside)
//        return button
//    }()
//
//    lazy var newGameCancelButton : UIButton = {
//        let button = UIButton()
//        button.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
//        button.setTitle("Cancel", for: .normal)
//        button.setTitleColor(.red, for: .normal)
//        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
//        button.layer.cornerRadius = 5
//        button.layer.masksToBounds = true
//
//        button.addTarget(self, action: #selector(newGameCancelButtonTapped), for: .touchUpInside)
//        return button
//    }()
//
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubviews(FutureGameButton, PreviousGameButton, CreateNewGameButton)
        setupFutureAndPreviuosButtonsConstraint()
        setUpaddNewGameInputContainerView()
      //  makeDatePicker()
        configurateNavigationBar()
    }
    
    func setupFutureAndPreviuosButtonsConstraint(){
        FutureGameButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 220))
      
        PreviousGameButton.anchor(top: FutureGameButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 220))
        
         CreateNewGameButton.anchor(top: PreviousGameButton.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 10), size: CGSize(width: 0, height: 220))
    }
    
    
    var NewGameInputContainerViewHeightAnchor = NSLayoutConstraint()
    
    func setUpaddNewGameInputContainerView() {
     //   addNewGameInputContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
     //   addNewGameInputContainerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
    //    addNewGameInputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
   //     NewGameInputContainerViewHeightAnchor = addNewGameInputContainerView.heightAnchor.constraint(equalToConstant: 0)
    //    NewGameInputContainerViewHeightAnchor.isActive = true
        
     //   addNewGameInputContainerView.addSubviews(newGameAddDateTextField,newGameAddLocationTextField,newGameCreateButton,newGameCancelButton)
//
        
      //  newGameAddDateTextField.anchor(top: addNewGameInputContainerView.topAnchor, leading: addNewGameInputContainerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: view.frame.width - 15, height: 50))
        
     //   newGameAddLocationTextField.anchor(top: newGameAddDateTextField.bottomAnchor, leading: addNewGameInputContainerView.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0), size: CGSize(width: view.frame.width - 15, height: 50))
        
     //   newGameCreateButton.anchor(top: newGameAddLocationTextField.bottomAnchor, leading: addNewGameInputContainerView.leadingAnchor, bottom: nil, trailing: nil, size: CGSize(width: view.frame.width / 2, height: 50))
        
     //   newGameCancelButton.anchor(top: newGameAddLocationTextField.bottomAnchor, leading: newGameCreateButton.trailingAnchor, bottom: nil, trailing: nil, size: CGSize(width: view.frame.width / 2, height: 50))
        
    }
    
    // MARK:- Handlers
//
//    func makeDatePicker() {
//        datePicker = UIDatePicker()
//        datePicker?.datePickerMode = .dateAndTime
//        datePicker?.addTarget(self, action: #selector(dateChanged(datePicker:)), for: .valueChanged)
//
//        newGameAddDateTextField.inputView = datePicker
//    }
//
//    @objc func createNewGameButtonTapped() {
//        self.NewGameInputContainerViewHeightAnchor.constant = 150
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//    }
    
    @objc func newGameCancelButtonTapped() {
        
        NewGameInputContainerViewHeightAnchor.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        view.endEditing(true)
    }

//
//    @objc func newGameAddButtonTapped() {
//        NewGameInputContainerViewHeightAnchor.constant = 0
//
//        UIView.animate(withDuration: 0.3) {
//            self.view.layoutIfNeeded()
//        }
//
//        if newGameAddDateTextField.text! != "" {
//            let alert = UIAlertController(title: "You created new game", message: "at: \(newGameAddDateTextField.text!) \n\(newGameAddLocationTextField.text!)", preferredStyle: .alert)
//            let action = UIAlertAction(title: "Ok", style: .default) { (action) in
//                self.createNewGame(dateHour: self.newGameAddDateTextField.text!, location:self.newGameAddLocationTextField.text!)
//            }
//            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//            alert.addAction(action)
//            alert.addAction(cancelAction)
//            present(alert,animated: true, completion: nil)
//        }
//
//        view.endEditing(true)
//    }
    
//    func createNewGame(dateHour:String, location: String){
//        guard let userTeam = userTeam else {return}
//        guard let userTeamName = userTeam.name else {return}
//        let date = String(dateHour.split(separator: " ").first!).replacingOccurrences(of: "/", with: "-")
//        let hour = String(dateHour.split(separator: " ").last!)
//
//        let param = ["hour": hour,
//                     "location":location
//        ]
//
//        DBService.shared.games.child(userTeamName).child(date).setValue(param)
//    }
//
//    @objc func dateChanged(datePicker: UIDatePicker) {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm"
//        newGameAddDateTextField.text = dateFormatter.string(from: datePicker.date)
//        let tapGesture = UITapGestureRecognizer(target: self , action: #selector(endEdditingDate))
//        view.addGestureRecognizer(tapGesture)
//    }
//
//    @objc func endEdditingDate(){
//        view.endEditing(true)
//        for recognizer in view.gestureRecognizers! {
//            view.removeGestureRecognizer(recognizer )
//        }
//    }
//
    
    @objc func previousGameTapped(){
        navigationController?.pushViewController(PreviousGameViewController(), animated: true)
    }
    
    @objc func createNewGameTapped(){
        navigationController?.pushViewController(CreateNewGameVC(), animated: true)
    }
    
    @objc func FutureGameTapped(){
        navigationController?.pushViewController(FutureGameViewController(), animated: true)
    }
    
    func configurateNavigationBar() {
        navigationController?.navigationBar.barTintColor = textDesign.navigationBarTintColor
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let goBackToHome = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackToHomeController))
        goBackToHome.setTitleTextAttributes(textDesign.navigationBarButtonItemAtrr, for: .normal)
        navigationItem.leftBarButtonItem = goBackToHome
        
//        let createNewGameButton =  UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(createNewGameButtonTapped))
//        createNewGameButton.tintColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
//        navigationItem.rightBarButtonItem = createNewGameButton
        
        self.navigationItem.title = "Games"
        
    }
    
    @objc func goBackToHomeController(){
        navigationController?.popViewController(animated: true)
    }
}
