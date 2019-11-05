//
//  StatsVC.swift
//  Soccer
//
//  Created by User on 08/09/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class StatsVC: UIViewController {
    
    private let textDesign = TextDesign()

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        
        configurateNavigationBar()
        
    }
    
    func configurateNavigationBar() {
        navigationController?.navigationBar.barTintColor = textDesign.navigationBarTintColor
        navigationController?.navigationBar.barStyle = .blackTranslucent
        
        let goBackToHome = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(goBackToHomeController))
        goBackToHome.setTitleTextAttributes(textDesign.navigationBarButtonItemAtrr, for: .normal)
        navigationItem.leftBarButtonItem = goBackToHome
        
        self.navigationItem.title = "Stats"

        
    }
    
    @objc func goBackToHomeController(){
        navigationController?.popViewController(animated: true)
    }


}
