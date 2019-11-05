//
//  TextDesign.swift
//  Soccer
//
//  Created by User on 27/10/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

struct TextDesign {
    let navigationBarButtonItemAtrr =  [NSAttributedString.Key.foregroundColor: #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1),
                              NSAttributedString.Key.font: UIFont(name: "Noteworthy", size: 18) ??
                                UIFont.systemFont(ofSize: 18)] as [NSAttributedString.Key : Any]
    
    let navigationBarButtonColor: UIColor = #colorLiteral(red: 0.721568644, green: 0.8862745166, blue: 0.5921568871, alpha: 1)
    
    let navigationBarAtrr =  [NSAttributedString.Key.foregroundColor: UIColor.white,
                              NSAttributedString.Key.font: UIFont(name: "Noteworthy", size: 25) ??
                                UIFont.systemFont(ofSize: 25)]
    
    let navigationBarTintColor = #colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)
}
