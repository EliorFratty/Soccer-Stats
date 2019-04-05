//
//  testViewController.swift
//  Soccer
//
//  Created by User on 04/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import Firebase

class testViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uploadImage.image = UIImage(named: "LoginPic")

    }
    
    var imageRef: String?

    @IBOutlet weak var uploadImage: UIImageView!
    
    @IBOutlet weak var donwloadImage: UIImageView!
    
    
    @IBAction func uploadClicked(_ sender: Any) {
        

    }
    
    @IBAction func downLoadClicked(_ sender: Any) {
        
        
        
        guard let imageRef = imageRef else { return }
        
        print(imageRef)
        
        guard let url = URL(string: imageRef) else {return}
        
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                self.popUpEror(error: error)
            }
            
            DispatchQueue.main.async {
                self.donwloadImage.image = UIImage(data: data!)
            }
        }.resume()

    }
}

