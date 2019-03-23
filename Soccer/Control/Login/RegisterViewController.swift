//
//  RegisterViewController.swift
//  Soccer Stats
//
//  Created by User on 05/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var emailTextfield: UITextField!
    
    @IBOutlet weak var passTextFiled: UITextField!
    
    @IBAction func regTapped(_ sender: UIButton) {
        Auth.auth().createUser(withEmail: emailTextfield.text!, password: passTextFiled.text!) { (user, error) in
            
            if error == nil {
                //SVProgressHUD.dismiss()
                self.performSegue(withIdentifier: "loggedIn", sender: self)
            } else {
                self.popUpEror(error: error!)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    



}
