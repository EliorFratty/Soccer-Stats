//
//  ContactUsPopUpVC.swift
//  KaduregelStats
//
//  Created by User on 06/08/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class ContactUsPopUpView: UIView {
    
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

    fileprivate let contactUsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.text = "Contact Us"
        label.textAlignment = .center
        return label
    }()
    
    fileprivate let container: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 24
        return v
    }()
    
    let emailTextFiled: UITextField = {
        let tf = UITextField()
        tf.placeholder = " Enter email"
        tf.clearButtonMode = .whileEditing
        tf.layer.borderWidth = 1
        tf.layer.cornerRadius = 5
        tf.layer.borderColor = UIColor.lightGray.cgColor
        
        return tf
    }()

    
    let descTextFiled: UITextView = {
        let tv = UITextView()
        tv.layer.borderWidth = 1
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.cornerRadius = 5
        tv.text =  "Go head, we are listening..."
        tv.textColor = UIColor.lightGray
        return tv
    }()
    
    let submitButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        button.setTitle("Submit", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.layer.cornerRadius = 5
        button.layer.masksToBounds = true
        
        button.addTarget(self, action: #selector(animateOut), for: .touchUpInside)
        
        return button
    }()
    
    func setupAnchors(){

        container.addSubviews(contactUsLabel, emailTextFiled, descTextFiled, submitButton)
        
        contactUsLabel.anchor(top: container.topAnchor, leading: container.leadingAnchor, bottom: nil, trailing: nil, size: CGSize(width: containerWidth, height: 50))
        
        emailTextFiled.anchor(top: contactUsLabel.bottomAnchor, leading: container.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 50, left: 10, bottom: 0, right: 0), size: CGSize(width: containerWidth - 20, height: 40))
        
        descTextFiled.delegate = self
        descTextFiled.anchor(top: emailTextFiled.bottomAnchor, leading: container.leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 5, left: 10, bottom: 0, right: 0), size: CGSize(width: containerWidth - 20, height: 100))
        
        submitButton.centerInXPositionSuperview(top: nil, bottom: container.bottomAnchor, padding: UIEdgeInsets(top: 0, left: 0, bottom: 30, right: 0), size: CGSize(width: 100, height: 30))
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension ContactUsPopUpView: UITextViewDelegate{
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Placeholder"
            textView.textColor = UIColor.lightGray
        }
    }
}

extension ContactUsPopUpView: UIGestureRecognizerDelegate{
    
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
