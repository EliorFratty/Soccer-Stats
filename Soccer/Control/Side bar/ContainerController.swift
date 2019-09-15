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

    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configurateHomeController()
    }

    //MARK: - Configurations

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
    
    //MARK: - Handlers
  
     func animateIn(sholdExpend: Bool, menuOption: MenuOption?) {
        if sholdExpend {
            setupTapGestureRecognizer()
            UIView.animate(withDuration: 0.7 ,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           animations: {
                            self.centerController.view.frame.origin.x  = self.centerController.view.frame.width - 120
                            self.centerController.view.alpha = 0.3

            },
                           completion: nil)
        }
        
        if let menuOption = menuOption {
            didSelectMenuOption(menuOption: menuOption)
            animateOut()
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
    
    func removeAllGestureRecognizer(){
        if let recognizers = view.gestureRecognizers {
            for recognizer in recognizers {
                view.removeGestureRecognizer(recognizer )
            }
        }
    }
}

extension ContainerController: HomeControllerDelegate {
    
     func handleMenuToggle(forMenuOption menuOption: MenuOption?) {
        if !isExpanded {
            configurateMenuController()
        }

        isExpanded = !isExpanded
        animateIn(sholdExpend: isExpanded, menuOption: menuOption)
    }
}

extension ContainerController: UIGestureRecognizerDelegate{
    
    func setupTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(animateOut))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }
    
    @objc func animateOut(){
        centerController.view.alpha = 1.0
        
        UIView.animate(withDuration: 0.7 ,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       animations: {
                        self.centerController.view.frame.origin.x  = 0
                       
                        
        },
                       completion: nil)
        
        isExpanded.toggle()
        removeAllGestureRecognizer()
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        if isExpanded{
            guard let menuControllerToch = menuController else {return false}

            if touch.view != menuControllerToch.view {
                    return true
                }
            return false
        }
        
        return true
    }
}

