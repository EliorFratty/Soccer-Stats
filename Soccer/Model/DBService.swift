//
//  DBService.swift
//  Soccer Stats
//
//  Created by User on 14/03/2019.
//  Copyright © 2019 User. All rights reserved.
//

import Foundation
import Firebase

class DBService {
 
    static let shared = DBService()
    private init() { }
    
    let Ref = Database.database().reference()
    let playerInTeamRef = Database.database().reference().child("playersInTeam")
    let users = Database.database().reference().child("users")
    

}
