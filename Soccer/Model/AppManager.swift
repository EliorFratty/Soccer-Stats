//
//  AppManager.swift
//  Soccer Stats
//
//  Created by User on 12/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation
import Firebase

class AppManager {
    
    static let shared = AppManager()
    
    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
    var appContainer: AppContainerViewController!
    
    private init() { }
    
    func showApp() {
        var viewCntroller: UIViewController

        if Auth.auth().currentUser == nil {
            viewCntroller = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        } else {
            viewCntroller = storyBoard.instantiateViewController(withIdentifier: "ChooseTeamViewController")
        }
        print(viewCntroller)
        
        appContainer.present(viewCntroller, animated: true, completion: nil)

    }
    
    func logOut() {
        try! Auth.auth().signOut()

    }
}
