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
    
    
    let allTeams = Database.database().reference().child("Teams")
    let users = Database.database().reference().child("users")

}
