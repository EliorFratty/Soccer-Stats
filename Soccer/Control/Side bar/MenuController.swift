//
//  MenuController.swift
//  Soccer
//
//  Created by User on 07/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class MenuController: UIViewController {
    
    //MARK: - Properties
    
    var delegate: HomeControllerDelegate?
    
    lazy var logoutButton : UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor.red
        
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitle("Log\nout", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false

        button.addTarget(self, action: #selector(logoutTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.loadImageUsingCatchWithUrlString(URLString: HomeController.userAsPlayer.profileImageUrl)
        imageView.backgroundColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    let userNameFullNameLabel: UILabel = {
       let lb = UILabel()
        lb.numberOfLines = 0
        lb.font = UIFont(name: "Arial", size: 30.0)
        
        lb.translatesAutoresizingMaskIntoConstraints = false

        return lb
    }()


    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        
        view.addSubviews(profileImageView, userNameFullNameLabel, logoutButton)

        profileImageAnchor()
        userNameFullNameLabelAnchor()
        logoutButtonAnchor()
    }

    //MARK: - Configurations

    func profileImageAnchor() {
        profileImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20) .isActive = true
        profileImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func userNameFullNameLabelAnchor() {
        userNameFullNameLabel.text = HomeController.userAsPlayer.fullName
        
        userNameFullNameLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 3) .isActive = true
        userNameFullNameLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        userNameFullNameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        userNameFullNameLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    func logoutButtonAnchor() {
        logoutButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20) .isActive = true
        logoutButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -65).isActive = true
        logoutButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    //MARK: - Handlers

    @objc func logoutTapped(){
        let menuOption = MenuOption(rawValue: 0)
        delegate?.handleMenuToggle(forMenuOption: menuOption)
    }
    
}
