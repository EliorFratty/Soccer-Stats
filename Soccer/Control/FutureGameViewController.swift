//
//  FutureGameViewController.swift
//  Soccer
//
//  Created by User on 16/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class FutureGameViewController: UIViewController {
    
    // MARK:- Propreties

    lazy var dismissButton : UIButton = {
        let button = UIButton()
        
        button.backgroundColor = UIColor.red
        
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.setTitle("Return", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        
        button.layer.cornerRadius = 25
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        
        
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK:- Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(dismissButton)
        setupDismissConstraint()

    }
    // MARK:- Handlers
    
    func setupDismissConstraint() {
        dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dismissButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    @objc func dismissTapped(){
        self.dismiss(animated: true, completion: nil)
    }
}
