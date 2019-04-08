//
//  ContainerController.swift
//  Soccer
//
//  Created by User on 08/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class ContainerController: UIViewController {
    
    //MARK: - Properties
    
    var menuController: UIViewController!
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
            
            view.insertSubview(menuController.view, at: 0)
            addChild(menuController)
            menuController?.didMove(toParent: self)
            print("added menu controller")
        }
    }
    
    func showMenuController(sholdExpend: Bool) {
        
        if sholdExpend {
            UIView.animate(withDuration: 0.7 ,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           animations: {
                            self.centerController.view.frame.origin.x  = self.centerController.view.frame.width - 120
            },
                           completion: nil)
        } else {
            UIView.animate(withDuration: 0.7 ,
                           delay: 0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           animations: {
                            self.centerController.view.frame.origin.x  = 0
            },
                           completion: nil)
        }
    }
    
    
    @objc func searchTeamFromAllUsers(){
        
        if !isExpanded {
            configurateMenuController()
        }
        
        isExpanded = !isExpanded
        showMenuController(sholdExpend: isExpanded)
        
    }
}

extension ContainerController: HomeControllerDelegate {
    func handleMenuToggle() {
        
        if !isExpanded {
            configurateMenuController()
        }
        
        isExpanded = !isExpanded
        showMenuController(sholdExpend: isExpanded)
        
    }
    
    
}
