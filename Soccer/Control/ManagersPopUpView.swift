//
//  ManagersPopUpView.swift
//  KaduregelStats
//
//  Created by User on 06/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class ManagersPopUpView: UIView {

    let containerWidth =  UIScreen.main.bounds.width * 0.75
    let containerHeight = UIScreen.main.bounds.height * 0.45
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.gray.withAlphaComponent(0.6)
        
        setupTapGestureRecognizer()
        
        self.addSubview(container)
        container.centerInSuperview(size: CGSize(width: containerWidth, height: containerHeight))
        
        animateIn()
        setupAnchors()
    }
    
    let scrollView: UIScrollView = {
       let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.backgroundColor = UIColor.clear
        sv.bounces = false
        sv.showsVerticalScrollIndicator = false
        
        return sv
    }()
    
    fileprivate let container: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        return v
    }()
    
    fileprivate let managersLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.text = "Managers"
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let nameManagerOneLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Almoni"
        return label
    }()
    
    fileprivate let nameManagerTwoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "Ploni"
        return label
    }()
    
    fileprivate let sendMessageToLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.text = "to: "
        return label
    }()

    
    let messageTextFiled: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        return tv
    }()
    
    let sendMessageMangerOneButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.setTitle("Send a Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(sendMessageManagerOne), for: .touchUpInside)
        
        return button
    }()
    
    let sendMessageMangerTwoButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.setTitle("Send a Message", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(sendMessageManagerTwo), for: .touchUpInside)
        
        return button
    }()
    
    let sendMessageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.setTitle("Send", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "Arial", size: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
        
        return button
    }()
    
    func setupAnchors(){
        
        container.addSubviews(managersLabel, sendMessageButton, sendMessageMangerTwoButton, sendMessageMangerOneButton, messageTextFiled, nameManagerTwoLabel, nameManagerOneLabel, sendMessageToLabel)
        
        managersLabel.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: nil, trailing: nil, size: CGSize(width: containerWidth, height: 50))
        
        let managerOneLabelHeight: CGFloat = 35
        let managerOneLabelwidth: CGFloat = (containerWidth - 10) / 2
        
        nameManagerOneLabel.anchor(top: managersLabel.bottomAnchor, leading: container.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 30, left: 10, bottom: 0, right: 0), size: CGSize(width: managerOneLabelwidth, height: managerOneLabelHeight))
        
        
         sendMessageMangerOneButton.anchor(top: nameManagerOneLabel.topAnchor, leading: nil, bottom: nil, trailing: container.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: managerOneLabelwidth, height: managerOneLabelHeight))
        
        nameManagerTwoLabel.anchor(top: nameManagerOneLabel.bottomAnchor, leading: container.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 10, left: 10, bottom: 0, right: 0), size: CGSize(width: managerOneLabelwidth, height: managerOneLabelHeight))
        
        
        sendMessageMangerTwoButton.anchor(top: nameManagerTwoLabel.topAnchor, leading: nil, bottom: nil, trailing: container.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10), size: CGSize(width: managerOneLabelwidth, height: managerOneLabelHeight))
        
        sendMessageToLabel.anchor(top: nameManagerTwoLabel.bottomAnchor, leading: container.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 3, left: 10, bottom: 0, right: 10), size: CGSize(width: containerWidth - 20 , height: 30))
        
        messageTextFiled.anchor(top: sendMessageToLabel.bottomAnchor, leading: container.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 10), size: CGSize(width: containerWidth - 20 , height: 100))
        
        sendMessageButton.centerInXPositionSuperview(top: messageTextFiled.bottomAnchor, bottom: nil, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0), size: CGSize(width: 80, height: 35))
        
    }
    
    @objc fileprivate func animateOut() {
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = CGAffineTransform(translationX: 0, y: +self.frame.height)
            self.alpha = 0
        }) { (complete) in
            if complete {
                self.removeFromSuperview()
            }
        }
    }
    
    @objc fileprivate func animateIn() {
        self.container.transform = CGAffineTransform(translationX: 0, y: +self.frame.height)
        self.alpha = 1
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            self.container.transform = .identity
            self.alpha = 1
        })
    }
    
    
    @objc func sendMessageManagerOne(){
        sendMessageToLabel.text = "to: Almoni"
        
        }
    
    @objc func sendMessageManagerTwo(){
        sendMessageToLabel.text = "to: Ploni"
        
    }
    
    @objc func sendMessage(){
        
        if let message = messageTextFiled.text {
            sendMassageToWhatsapp(msg: message, number: "0544944098")
        }
        
        animateOut()
    }
    
    func sendMassageToWhatsapp(msg: String, number: String) {
        let urlWhats = "whatsapp://send?phone=+972\(number.dropFirst())&text=\(msg)"
        
        var characterSet = CharacterSet.urlQueryAllowed
        characterSet.insert(charactersIn: "?&")
        
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: characterSet){
            
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL){
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: nil)
                }
                else {
                    print("Install Whatsapp")
                    
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ManagersPopUpView: UIGestureRecognizerDelegate{
    
    func setupTapGestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(animateOut))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view == container {
            return false
        }
        return true
    }
    
}
