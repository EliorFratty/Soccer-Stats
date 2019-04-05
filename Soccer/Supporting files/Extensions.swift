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
