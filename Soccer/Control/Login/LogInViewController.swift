//
//  LogInViewController.swift
//  Soccer Stats
//
//  Created by User on 05/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class LogInViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let inputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var loginRegisterButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = UIColor.red
        button.setTitle("Register", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(registerLoginTapped), for: .touchUpInside)
        return button
    }()
    
    
    let nameTextFiled: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        tf.keyboardType = .emailAddress

        return tf
    }()
    
    let nameSepratorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let emailTextFiled: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.keyboardType = .emailAddress
        tf.clearButtonMode = .whileEditing

        return tf
    }()
    
    let emailSepratorView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.22, green: 0.22, blue: 0.22, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    let passwordTextFiled: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.clearButtonMode = .whileEditing
        
        return tf
    }()
    
    lazy var profileImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.image = UIImage(named: "LoginPic")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(selectedProfileImage)))
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    @objc func selectedProfileImage(){
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let edditedImage = info[.editedImage] {
            selectedImageFromPicker = edditedImage as? UIImage
            
        } else if let originalImage = info[.originalImage] {
            selectedImageFromPicker = originalImage as? UIImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            profileImageView.image = selectedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let sc = UISegmentedControl(items: ["Login", "Register"])
        sc.translatesAutoresizingMaskIntoConstraints = false
        sc.tintColor = .white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(loginRegisterHasChanged), for: .valueChanged)
        return sc
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 0.81, green: 0.31, blue: 0.31, alpha: 1)
        view.addSubview(inputContainerView)
        view.addSubview(loginRegisterButton)
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        self.hideKeyboard()
        setupinputContainerViewConstraint()
        setUploginRegisterSegmentedControl()
        setUpLoginRegisterButton()
        setUpProfileImageView()
        
    }
    
    //MARK: - Anchor's
    // need x, y, width, height
    
    func setUploginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputContainerView.topAnchor, constant: -10).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func setUpProfileImageView(){
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: -10).isActive = true
        profileImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1/2, constant: -24).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        
    }
    
    func setUpLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputContainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true

    }
    
    var inputContaunerViewHeightAnchor: NSLayoutConstraint?
    var nameTextFieldHeightAnchor: NSLayoutConstraint?
    var emailTextFieldHeightAnchor: NSLayoutConstraint?
    var passwordTextFieldHeightAnchor: NSLayoutConstraint?

    func setupinputContainerViewConstraint(){
        inputContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputContainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1, constant: -24).isActive = true
        inputContaunerViewHeightAnchor = inputContainerView.heightAnchor.constraint(equalToConstant: 150)
        inputContaunerViewHeightAnchor?.isActive = true
        
        inputContainerView.addSubview(nameTextFiled)
        inputContainerView.addSubview(emailTextFiled)
        inputContainerView.addSubview(passwordTextFiled)
        inputContainerView.addSubview(nameSepratorView)
        inputContainerView.addSubview(emailSepratorView)
        
        nameTextFiled.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        nameTextFiled.topAnchor.constraint(equalTo: inputContainerView.topAnchor).isActive = true
        nameTextFiled.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        nameTextFieldHeightAnchor = nameTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        nameTextFieldHeightAnchor?.isActive = true
        
        nameSepratorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        nameSepratorView.topAnchor.constraint(equalTo: nameTextFiled.bottomAnchor).isActive = true
        nameSepratorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        nameSepratorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextFiled.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        emailTextFiled.topAnchor.constraint(equalTo: nameSepratorView.bottomAnchor).isActive = true
        emailTextFiled.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        emailTextFieldHeightAnchor = emailTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        emailTextFieldHeightAnchor?.isActive = true
        
        emailSepratorView.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor).isActive = true
        emailSepratorView.topAnchor.constraint(equalTo: emailTextFiled.bottomAnchor).isActive = true
        emailSepratorView.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor).isActive = true
        emailSepratorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextFiled.leftAnchor.constraint(equalTo: inputContainerView.leftAnchor, constant: 12).isActive = true
        passwordTextFiled.topAnchor.constraint(equalTo: emailSepratorView.bottomAnchor).isActive = true
        passwordTextFiled.widthAnchor.constraint(equalTo: inputContainerView.widthAnchor, constant: -24).isActive = true
        passwordTextFieldHeightAnchor = passwordTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor, multiplier: 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
    }
    
    // MARK: - Register & Login
    
    @objc func registerLoginTapped(_ sender: UIButton) {
        sender.pulsate()
        
        loginRegisterSegmentedControl.selectedSegmentIndex == 1 ? registerToTheSystem() : loginToTheSystem()
        
    }
    
    func registerToTheSystem(){
        guard let email = emailTextFiled.text,
            let pass = passwordTextFiled.text,
            let name = nameTextFiled.text else { return }
        
        Auth.auth().createUser(withEmail: email, password: pass) { (user, error) in
            
            if let error = error {
                self.popUpEror(error: error)
                return
            }
            
            guard let userID = user?.user.uid else {return}  
            guard let profileImage = self.profileImageView.image else { print("errorSetImage");return}
            guard let profileImageData = profileImage.jpegData(compressionQuality: 0.1) else { print("errorSetImageData");return}
            let fileName = "\(userID).jpg"
            
            let uploadImageRef = DBService.shared.storageRef.child(fileName)
            
            let uploadTask = uploadImageRef.putData(profileImageData, metadata: nil) { (metadata, error) in
                
                if let error = error {
                    self.popUpEror(error: error)
                    return
                }

                DispatchQueue.main.async {
                    uploadImageRef.downloadURL(completion: { (url, error) in
                        if let url = url {
                            let param = ["fullName": name,
                                         "email" : email,
                                         "profileImageUrl" :  url.absoluteString]
                            
                            DBService.shared.users.child(userID).setValue(param)
                        }
                    })
                }
            }
            
            uploadTask.observe(.success) { (snapshot) in
                self.dismiss(animated: true, completion: nil)
            }
            
                uploadTask.resume()
        }   
    }
    
    func loginToTheSystem(){

        guard let email = emailTextFiled.text, let pass = passwordTextFiled.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: pass) { [self] user, error in
            
            if let _ = user {
                self.dismiss(animated: true, completion: nil)
                UserDefaults.standard.set(email, forKey: "userEmail")
                UserDefaults.standard.set(pass, forKey: "userPass")
            } else {
                self.popUpEror(error: error!)
            }
        }
    }
    
    @objc func loginRegisterHasChanged() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        inputContaunerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        nameTextFieldHeightAnchor?.isActive = false
        passwordTextFieldHeightAnchor?.isActive = false
        emailTextFieldHeightAnchor?.isActive = false
        
        nameTextFieldHeightAnchor = nameTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor,
                                                                          multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        
        nameTextFieldHeightAnchor?.isActive = true
        passwordTextFieldHeightAnchor = passwordTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor,
                                                                                  multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordTextFieldHeightAnchor?.isActive = true
        emailTextFieldHeightAnchor = emailTextFiled.heightAnchor.constraint(equalTo: inputContainerView.heightAnchor,
                                                                            multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailTextFieldHeightAnchor?.isActive = true
 
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            emailTextFiled.text = UserDefaults.standard.object(forKey: "userEmail") as? String
            passwordTextFiled.text = UserDefaults.standard.object(forKey: "userPass") as? String
        } else {
            emailTextFiled.text = ""
            passwordTextFiled.text = ""
        }
    }
}
