//
//  File.swift
//  Soccer
//
//  Created by User on 07/04/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit
import LBTATools

class ChooseTeamCell: UITableViewCell {
    
    var team: Team? {
        didSet{
            textLabel?.text = team?.name
            detailTextLabel?.text = team?.teamSummary
            imojiLabel.text = team?.teamImoji
            
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let imojiLabel: UILabel = {
        let imojiLabel = UILabel()
        imojiLabel.font = UIFont(name: "Arial-BoldMT", size: 45)
        
        imojiLabel.translatesAutoresizingMaskIntoConstraints = false
        
        return imojiLabel
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(imojiLabel)
        imojiLabelAnchor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func imojiLabelAnchor() {
                
        imojiLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8) .isActive = true
        imojiLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        imojiLabel.widthAnchor.constraint(equalToConstant: 48).isActive = true
        imojiLabel.heightAnchor.constraint(equalToConstant: 48).isActive = true
  
    }
    
}
