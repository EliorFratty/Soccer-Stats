//
//  UserCell.swift
//  Soccer
//
//  Created by User on 05/05/2019.
//  Copyright © 2019 User. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    let profileImageViewHeight:CGFloat = 48
    
    var player: Player? {
        didSet{
            textLabel?.text = player?.fullName
            detailTextLabel?.text = player?.email
            profileImageView.loadImageUsingCatchWithUrlString(URLString: player!.profileImageUrl)
        }
    }
 
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y-2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y+2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = profileImageViewHeight/2
        imageView.layer.masksToBounds = true
        
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageAnchor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func profileImageAnchor() {
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8) .isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: profileImageViewHeight).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: profileImageViewHeight).isActive = true
    }
}
