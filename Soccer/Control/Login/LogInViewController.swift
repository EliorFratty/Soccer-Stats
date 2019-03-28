//
//  LogInViewController.swift
//  Soccer Stats
//
//  Created by User on 05/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController {

    @IBOutlet weak var emailTextFiled: UITextField!    
    @IBOutlet weak var passwordTextField: UITextField!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    @IBAction func logInTapped(_ sender: UIButton) {
        //SVProgressHUD.show()
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.gray
        view.addSubview(activityIndicator)
        
        guard let email =  emailTextFiled.text, let pass = passwordTextField.text else {
            return
        }
        activityIndicator.startAnimating()
        Auth.auth().signIn(withEmail: email, password: pass) { [self] user, error in
            self.activityIndicator.stopAnimating()

            if let _ = user {
                //SVProgressHUD.dismiss()
                self.dismiss(animated: true, completion: nil)
                UserDefaults.standard.set(email, forKey: "userEmail")
                UserDefaults.standard.set(pass, forKey: "userPass")
            } else {
                self.popUpEror(error: error!)
                
            }
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let savedUser = UserDefaults.standard.object(forKey: "userEmail")
        let savedPass = UserDefaults.standard.object(forKey: "userPass")
        emailTextFiled.text = savedUser as? String
        passwordTextField.text = savedPass as? String
    }

}

extension UIViewController {
    func popUpEror(error: Error){
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Retary", style: .default, handler: nil)
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    func popUpEror(error123: String){
        let alert = UIAlertController(title: "Error", message: error123, preferredStyle: .alert)
        let action = UIAlertAction(title: "Retary", style: .default, handler: nil)
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
}
