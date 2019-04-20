//
//  ContainerController.swift
//  Soccer
//
//  Created by User on 08/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class ContainerController: UIViewController {
    
    //MARK: - Properties
    
    var menuController: MenuController!
    var centerController: UIViewController!

    var isExpanded = false

    //MARK: - Init
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurateHomeController()
    }

    //MARK: - Handlers
    
    func configurateHomeController(){
    
        let homeController = HomeController()
        homeController.delegate = self
        centerController = UINavigationController(rootViewController: homeController)
        
        view.addSubview(centerController.view)
        addChild(centerController)
        centerController.didMove(toParent: self)
        
    }

    func configurateMenuController() {
        if menuController == nil {
            menuController = MenuController()
            menuController.delegate = self
            
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController.didMove(toParent: self)
        } else {
            menuController.userNameFullNameLabel.text = HomeController.userAsPlayer.fullName
        }
    }
    
    func animatePanel(sholdExpend: Bool, menuOption: MenuOption?) {
        
        if sholdExpend {
            UIView.animate(withDuration: 0.7 ,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           animations: {
                            self.centerController.view.frame.origin.x  = self.centerController.view.frame.width - 120
                            self.centerController.view.alpha = 0.3

            },
                           completion: nil)
        } else {
            UIView.animate(withDuration: 0.7 ,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           animations: {
                            self.centerController.view.frame.origin.x  = 0
                            self.centerController.view.alpha = 1.0

            },
                           completion: nil)
        
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           options: .curveEaseInOut,
                           animations: { [self] in
                           self.centerController.view.frame.origin.x = 0
                            
            }) { [self] (_) in
                guard let menuOption = menuOption else {return}
                self.didSelectMenuOption(menuOption: menuOption)
            }
        }
    }
    
    func didSelectMenuOption(menuOption: MenuOption) {
        
        switch menuOption{
            case .logout: logout()
        }
    }
    
    func logout(){
        try! Auth.auth().signOut()
        let viewCntroller = LogInViewController()
        self.present(viewCntroller, animated: true, completion: nil)
    }
}

extension ContainerController: HomeControllerDelegate {
    
     func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configurateMenuController()
        }

        isExpanded = !isExpanded
        animatePanel(sholdExpend: isExpanded, menuOption: menuOption)
    }
}

