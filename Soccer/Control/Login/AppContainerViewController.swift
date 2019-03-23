//
//  dd.swift
//  
//
//  Created by User on 20/03/2019.
//

import UIKit

class AppContainerViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        AppManager.shared.appContainer = self
        AppManager.shared.showApp()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
