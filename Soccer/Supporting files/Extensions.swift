//
//  Extensions.swift
//  Soccer
//
//  Created by User on 05/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadImageUsingCatchWithUrlString(URLString: String){
        
        self.image = nil
        
        if let chachedImage = imageCache.object(forKey: URLString as AnyObject) as? UIImage {
            self.image = chachedImage
            return
        }
        
        
        
        let url = URL(string: URLString)
        
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if let error = error {
               print(error)
                return
            }
            
            DispatchQueue.main.async {
                
                if let downloadedImage = UIImage(data: data!) {
                    imageCache.setObject(downloadedImage, forKey: URLString as AnyObject)
                    self.image = downloadedImage

                }
            }
            }.resume()
    }
    
}

extension UIButton {
    
    func pulsate() {
        
        let puls = CASpringAnimation(keyPath: "transform.scale")
        puls.duration = 0.6
        puls.fromValue = 1.0
        puls.toValue = 0.9
        puls.autoreverses = true
        puls.repeatCount = 1
        puls.initialVelocity = 0.5
        puls.damping = 1.0
        
        layer.add(puls, forKey: nil)

    }
    
    func flash() {
        
        let puls = CASpringAnimation(keyPath: "opacity")
        puls.duration = 0.5
        puls.fromValue = 1
        puls.toValue = 0.1
        puls.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        puls.autoreverses = true
        puls.repeatCount = 3

        layer.add(puls, forKey: nil)
        
    }
    
    func shake() {
        
        let puls = CASpringAnimation(keyPath: "position")
        puls.duration = 0.1

        puls.autoreverses = true
        puls.repeatCount = 2
        
        let fromPoint = CGPoint(x: center.x - 5, y: center.y)
        let fromValue = NSValue(cgPoint: fromPoint)
        
        let toPoint = CGPoint(x: center.x + 5, y: center.y)
        let toValue = NSValue(cgPoint: toPoint)

        puls.fromValue = fromValue
        puls.toValue = toValue

        layer.add(puls, forKey: nil)
        
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

extension UIView {
    
    func anchor(top: NSLayoutYAxisAnchor? = nil, left: NSLayoutXAxisAnchor? = nil,bottom:NSLayoutYAxisAnchor? = nil,right: NSLayoutXAxisAnchor? = nil,
                    paddindTop:CGFloat? = 0,paddindLeft:CGFloat? = 0,paddindBottom:CGFloat? = 0,paddindRight:CGFloat? = 0,
                    width:CGFloat? = 0, height:CGFloat? = 0) {
        
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: paddindTop!).isActive = true
        }
        if let left = left {
            leftAnchor.constraint(equalTo: left, constant: paddindLeft!).isActive = true
        }
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddindBottom!).isActive = true
        }
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddindRight!).isActive = true
        }
        if let width = width {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        if let height = height {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}
