//
//  Extensions.swift
//  Soccer
//
//  Created by User on 05/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit


enum MenuOption: Int, CustomStringConvertible {
    
    case logout
    
    var description: String {
        switch self {
        case .logout:
            return "Logout"
        }
    }
  
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView{
    
    func loadImageUsingCatchWithUrlString(URLString: String){
        
        self.image = nil
        
        if let chachedImage = imageCache.object(forKey: URLString as AnyObject) as? UIImage {
            self.image = chachedImage
            return
        }
        
        
        
        let url = URL(string: URLString)
        
        guard let url2 = url else {print("cantuplaodImageWith?url") ; return}
        
        URLSession.shared.dataTask(with: url2) { (data, response, error) in
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
    
    func popUpEror(error: String){
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        let action = UIAlertAction(title: "Retary", style: .default, handler: nil)
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
}

extension Date {
    func toString(dateFormat format: String ) -> String {
        let dateFormater = DateFormatter()
        dateFormater.dateFormat = format
        return dateFormater.string(from: self)
    }
}
